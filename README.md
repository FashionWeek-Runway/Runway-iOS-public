# Runway-iOS
- 온라인과 오프라인을 연결해주는 O4O 서비스
- 오프라인 쇼핑 지도를 통해, 오프라인 쇼핑을 원하는 사용자에게 편리한 서비스를 제공합니다.

<a href="https://apps.apple.com/us/app/%EB%9F%B0%EC%9B%A8%EC%9D%B4-runway-%EB%82%B4-%EC%86%90-%EC%95%88%EC%9D%98-%EA%B0%84%ED%8E%B8%ED%95%9C-%ED%8C%A8%EC%85%98-%EC%87%BC%ED%95%91-%EC%A7%80%EB%8F%84/id1671808515">
 <img src = "https://user-images.githubusercontent.com/69136340/165884844-de14d6f9-5e3a-4796-b880-f79d88186b27.png">
</a>

---
<img width="526" alt="대지 1@4x 1" src="https://user-images.githubusercontent.com/46420281/227476808-80d481f2-a55f-4522-ba0e-efc7b8b7d8b4.png">

## ⚒ 아키텍처

| 전체 아키텍처

![runway_architecture](https://user-images.githubusercontent.com/46420281/228124620-0e3f8f20-13f2-47b8-88f5-09b435e9dbfc.png)
---
> **MVVM(ReactorKit)**

 ![image](https://user-images.githubusercontent.com/46420281/227477622-78ab297d-f315-4048-ae9b-e40e7d925272.png)
 - MVVM을 도입하여 View는 화면을 그리는데에 집중하고, ViewModel을 통해 Side Effect와 State를 처리하도록 했습니다.
   - 이를 통해 기존의 MVC 방식의 문제인 Massive ViewController 문제를 해결하고자 했습니다.
 - UIKit 요소가 없어도 뷰에 보여질 값들을 ViewModel을 통해 단독으로 단위 테스트하여 확인하고 검증할 수 있게 했습니다.
   - 이를 위해 ViewModel은 UIKit을 import 하지 않는 원칙을 지키며 구현했습니다.
 
> **Coordinator**
 - RxFlow를 사용하여 화면전환을 정의하고, ViewModel에서 Step을 통해 Coordinator(Flow)에서 화면전환을 처리하도록 했습니다. 
 - 각 Flow에서 각 클래스의 생성과 의존성 주입을 구현하여, 클래스간 결합도를 낮추고 변경 가능성을 줄였습니다.
 
> **Repository Pattern**
- Repository Pattern을 통해 데이터를 요청하는 역할을 ViewModel에서 분리하여 ViewModel이 비즈니스 로직 처리 역할에 집중하도록 했습니다.
- Repository는 ServiceProvider 라는 프로토콜로 추상화하여 ViewModel과의 결합을 느슨히 하여 변경 가능성을 낮추었습니다.
- 여러 ViewModel 에서 일관된 인터페이스를 통해 데이터를 요청할 수 있게 했습니다.

## 기술적 도전
### 🔬RxSwift, RxCocoa
- 연속된 콜백 지옥을 피하고, 기존 delegate 패턴의 분산적 코드의 개선을 위해 사용하였습니다.
- 사용자의 액션으로부터 상태가 변화하여 다시 뷰에 그려지기까지 스트림으로 데이터를 처리하도록 했습니다.

# 🔬RxFlow
- 클래스간 의존성 주입을 용이하게 하고, MVVM 패턴에서 Coordinator의 화면 전환을 트리거 하게 하기 위해 사용했습니다.

# 🔬RxFlow
- 클래스간 의존성 주입을 용이하게 하고, MVVM 패턴에서 Coordinator의 화면 전환을 트리거 하게 하기 위해 사용했습니다.

## Todo
# 🖼️ URL Image Load, Caching
- URL 로부터의 이미지 로드, 캐싱은 Kingfisher 라이브러리로 처리하였으나 의존성을 제거하고 직접 이미지 로드, 캐싱을 구현할 예정입니다.

# 🪛 Rx TestCode
- 테스트 코드를 구현할 예정입니다.
