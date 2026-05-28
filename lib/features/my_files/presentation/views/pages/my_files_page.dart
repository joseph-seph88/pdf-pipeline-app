import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pdf_pipeline_app/app/router/app_navigation.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import 'package:pdf_pipeline_app/core/utils/date_formatter.dart';
import 'package:pdf_pipeline_app/features/my_files/providers/my_files_providers.dart';
import 'package:pdf_pipeline_app/features/my_files/presentation/states/my_files_state.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/toast/app_toast.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_loading_overlay.dart';
import 'package:pdf_pipeline_app/shared/widgets/filename_input_sheet.dart';
import '../../notifiers/my_files_notifier.dart';
import '../../states/user_state.dart';
import '../widgets/document_list_item.dart';
import '../widgets/my_files_app_bar.dart';
import '../widgets/my_files_empty_view.dart';
import '../widgets/my_files_error_view.dart';
import '../widgets/my_files_profile_card.dart';

class MyFilesPage extends ConsumerWidget {
  const MyFilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFilesProvider);
    final profile = ref.watch(userProvider).user;
    final notifier = ref.read(myFilesProvider.notifier);

    ref.listen<UserState>(userProvider, (prev, next) {
      if (next.updateError != null && next.updateError != prev?.updateError) {
        ref.read(userProvider.notifier).clearUpdateError();
        AppToast.show(next.updateError!);
      }
    });

    ref.listen<MyFilesState>(myFilesProvider, (prev, next) {
      if (next.pendingBytes != null &&
          next.pendingDocument != null &&
          prev?.pendingBytes != next.pendingBytes) {
        notifier.clearDownload();
        context.pushToPdfViewer(
          bytes: next.pendingBytes!,
          name: next.pendingDocument!.originalName,
        );
      }
      if (next.downloadError != null &&
          next.downloadError != prev?.downloadError) {
        notifier.clearDownload();
        AppToast.show(next.downloadError!);
      }

      if (next.pendingShareBytes != null && prev?.pendingShareBytes == null) {
        if (!context.mounted) return;
        _handlePendingShare(context, ref, next.pendingShareBytes!);
      }
      if (next.mergeError != null && next.mergeError != prev?.mergeError) {
        notifier.clearShareState();
        AppToast.show(next.mergeError!);
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundGrey,
          appBar: buildMyFilesAppBar(state: state, notifier: notifier),
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => notifier.loadDocuments(),
            child: CustomScrollView(
              slivers: [
                if (!state.isSelectionMode)
                  SliverToBoxAdapter(
                    child: MyFilesProfileCard(
                      profile: profile,
                      onLogout: () => ref
                          .read(authStateProvider.notifier)
                          .logout(ref.read(tokenStorageProvider)),
                      onEdit: () => context.pushToProfileEdit(),
                    ),
                  ),
                ..._buildContentSlivers(context, ref, state, notifier),
              ],
            ),
          ),
        ),
        if (state.isProcessing)
          AppLoadingOverlay(label: state.isMerging ? '병합 중...' : null),
      ],
    );
  }

  List<Widget> _buildContentSlivers(
    BuildContext context,
    WidgetRef ref,
    MyFilesState state,
    MyFilesNotifier notifier,
  ) {
    if (state.status == MyFilesStatus.failure) {
      return [
        SliverFillRemaining(
          child: MyFilesErrorView(
            message: state.errorMessage ?? '파일 목록을 불러올 수 없습니다.',
            onRetry: notifier.loadDocuments,
          ),
        ),
      ];
    }

    if (state.status == MyFilesStatus.loading) {
      return [
        SliverToBoxAdapter(
          child: Skeletonizer(
            enabled: true,
            child: Column(
              children: List.generate(
                6,
                (_) =>
                    DocumentListItem(document: _skeletonDocument, onTap: () {}),
              ),
            ),
          ),
        ),
      ];
    }

    if (state.isEmpty) {
      return [const SliverFillRemaining(child: MyFilesEmptyView())];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
          child: Text(
            state.isSelectionMode
                ? '총 ${state.documents.length}개 · 길게 눌러 선택'
                : '총 ${state.documents.length}개',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textCaption,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(bottom: 24.h),
        sliver: SliverList.builder(
          itemCount: state.documents.length,
          itemBuilder: (ctx, i) {
            final doc = state.documents[i];
            final isSelected = state.selectedIds.contains(doc.id);
            return DocumentListItem(
              document: doc,
              isSelectionMode: state.isSelectionMode,
              isSelected: isSelected,
              onTap: () {
                if (state.isSelectionMode) {
                  notifier.toggleSelection(doc.id);
                } else {
                  notifier.openDocument(doc);
                }
              },
            );
          },
        ),
      ),
    ];
  }

  Future<void> _handlePendingShare(
    BuildContext context,
    WidgetRef ref,
    Uint8List bytes,
  ) async {
    final notifier = ref.read(myFilesProvider.notifier);
    notifier.clearShareState();

    final defaultName = 'merge_${formatDateCompact(DateTime.now())}';

    if (!context.mounted) return;
    final rawName =
        await showFilenameInputSheet(context, defaultName: defaultName);
    if (rawName == null) return;

    final trimmed = rawName.trim();
    final fileName = trimmed.isEmpty
        ? '$defaultName.pdf'
        : trimmed.toLowerCase().endsWith('.pdf')
            ? trimmed
            : '$trimmed.pdf';

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], subject: fileName);

    notifier.exitSelectionMode();
  }

  static final _skeletonDocument = Document(
    id: 'skeleton',
    originalName: 'document_file_name_sample.pdf',
    fileSize: 204800,
    downloadUrl: '',
    createdAt: DateTime.now(),
  );
}
