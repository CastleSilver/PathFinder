# 🛣 Path Finder
![로고](https://user-images.githubusercontent.com/95426849/223027980-1d0f8ffb-72cf-4b2c-89c0-3da9dbdc9a69.png)

---
## 📱 어플 소개

+ 프로젝트명: Path Finder
+ 한줄 소개: 아주 심플하고 단순한 길 찾기 앱
+ 기간: 2023. 3. 6 ~ 23. 4. 6
+ 사용 기술:
  + 관리: Github, Notion
  + 언어: Swift 5
  + IDEA: Xcode 14.2
  + 라이브러리: Lottie, XCTest, UIKit, CoreLocation, Alamofire, NMapMap, TMapAPI

</br>

---

</br>

## 💎 기획
### 프로토 타입
[피그마 링크](https://www.figma.com/file/ciWBy5tSR6hnjq8KxuyfHK/PathFinder?node-id=0%3A1&t=rF9eltUmoHpXZHb1-1)
![image](https://user-images.githubusercontent.com/95426849/223025032-f0de09fa-7d1c-4f5a-89a9-e2bddac3731f.png)

#### 정상 실행 시
![프로토타입](https://user-images.githubusercontent.com/95426849/223024750-f7be5d8d-ec1f-4467-8531-f7467a809fa0.gif)

#### 오류 발생 시
![오류화면](https://user-images.githubusercontent.com/95426849/223025380-d7a0ca14-08d5-485c-bc48-ec5bd37bf1ea.gif)

### 기능 명세서
![image](https://user-images.githubusercontent.com/95426849/223306525-324d66e0-373a-4777-bbaa-e68f0f2ed831.png)

</br>

---

</br>

## 📚 주요 기능
### Splash View
+ 프로젝트 로고를 확인할 수 있다.
+ lottie animation을 확인할 수 있다.

### Main View
+ 네이버 맵 SDK를 이용해 구현된 지도를 확인할 수 있다.
+ 현재 내 위치가 붉은 점으로 표시되서 화면에 나타난다.
+ 지도 화면 정중앙에 출발 마커가 있고 마커가 가르키는 위치가 하단 출발지 입력창에 자동으로 표시되어 나타난다.
+ 지도 뷰 우측 하단의 '위치 조정 버튼'을 누르면 내 위치로 출발 마커가 이동한다.
+ 도착지가 입력되지 않으면 결과 창으로 이동하는 '다음' 버튼이 활성화되지 않는다.
+ 도착지가 입력될 경우 '다음' 버튼이 활성화되고 결과창으로 이동할 수 있다.

### Search View
+ 메인 화면의 출발지/도착지 입력창을 클릭하면 이동하는 화면이다.
+ 출발지 입력창을 클릭했는지, 도착지 입력창을 클릭했는지에 따라 검색창의 placeholder가 다르게 표시된다.
+ 검색창에 이동하고 싶은 지역을 검색하면 타이핑이 될 때마다 Tmap POI API가 호출되어 관련 지역이 정확도 순으로 출력된다.
+ 검색 결과 중 하나를 클릭하면 해당 지역이 출발지/도착지에 입력된다.
+ 클릭된 검색 결과는 Userdefaults에 저장되고 검색 히스토리에서 확인 가능하다.
+ 검색 히스토리가 존재하지 않을 경우 '검색 내역이 존재하지 않습니다'라는 안내 문구가 표시된다.
+ 검색 히스토리가 존재한다면 이전 검색 내역이 표시 되고 '검색 히스토리 삭제' 버튼이 생성되어 해당 버튼을 눌러 검색 히스토리를 삭제할 수 있다.
+ 검색창 하단의 '내 위치' 버튼을 누르면 출발지/도착지가 내 위치 주소로 입력된다.
+ '지도에서 설정' 버튼을 입력하면 Map View 화면으로 이동한다.

### Map View
+ 이전 화면이 출발지/도착지 검색화면이었는지에 따라 화면의 테마색이 변경된다.
+ 네이버 맵 SDK를 이용해 구현된 지도를 확인할 수 있고 기본 화면 구성은 메인 화면과 유사하다.
+ 메인화면과 동일하게 '위치 조정 버튼'을 눌러 내 위치로 다시 돌아올 수 있다.
+ 지도를 이동하면 하단창에 현재 위치가 출력된다.
+ 하단의 '출발지/도착지로 설정' 버튼을 눌러 가르키고 있는 위치를 메인화면의 출발지/도착지로 설정할 수 있다.

### Result View
+ '경로 설정이 완료되었습니다!' 라는 안내 문구가 출력 된다.
+ 출발지/도착지를 어디로 설정하였는지 확인 가능하다.
+ lottie animation이 화면에 생성된다.
+ 좌측 상단에 back button을 눌러 main view로 이동할 수 있다.
