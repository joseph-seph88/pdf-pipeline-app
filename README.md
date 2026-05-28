# PDF Pipeline App

PDF 업로드·변환·파일 관리를 지원하는 Flutter 기반 모바일 앱입니다.

## Version

- **Flutter**: 3.35.4

## Developer

- **Name**: Joseph88
- **Email**: pathetic.sim@gmail.com

---

## 기술 스택

| 분류 | 라이브러리 |
|------|-----------|
| 상태관리 | flutter_riverpod |
| 라우팅 | go_router |
| 네트워크 | dio |
---

## 코드 구조

```
lib/
├── main.dart          # 앱 진입점, .env 로드 및 bootstrap 호출
├── app/               # 앱 초기화 및 GoRouter 라우팅 설정
├── core/              # 앱 전역 로직
├── features/          # 기능 단위 모듈, 각각 Clean Architecture 레이어로 분리
└── shared/            # 공통 UI (디자인 시스템)
```

### 아키텍처

Clean Architecture 기반으로 각 feature를 **data / domain / presentation** 3개 레이어로 분리합니다.

- **presentation**: UI 및 Riverpod Notifier/State
- **domain**: Repository 인터페이스 정의
- **data**: API 호출, 모델, Repository 구현체
