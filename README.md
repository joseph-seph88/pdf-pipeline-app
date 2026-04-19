# PDF Pipeline App

PDF 업로드·변환·파일 관리를 지원하는 Flutter 기반 모바일 앱입니다.

## Developer

- **Name**: Joseph88
- **Email**: pathetic.sim@gmail.com

---

## 기술 스택

| 분류 | 라이브러리 |
|------|-----------|
| 상태관리 | flutter_riverpod |
| 라우팅 | go_router |
| 네트워크 | dio, pretty_dio_logger |
---

## 코드 구조

```
lib/
├── main.dart          # 앱 진입점, .env 로드 및 bootstrap 호출
├── app/               # 앱 초기화 및 GoRouter 라우팅 설정
├── core/              # 네트워크, 세션, 에러, 테마 등 feature에 종속되지 않는 전역 모듈
├── features/          # 기능 단위 모듈, 각각 Clean Architecture 레이어로 분리
└── shared/            # 여러 feature가 공통으로 쓰는 페이지·유틸
```

### 아키텍처

Clean Architecture 기반으로 각 feature를 **data / domain / presentation** 3개 레이어로 분리합니다.

- **presentation**: UI 및 Riverpod Notifier/State
- **domain**: Repository 인터페이스 정의
- **data**: API 호출, 모델, Repository 구현체
