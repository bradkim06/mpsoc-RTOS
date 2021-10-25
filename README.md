# mpsoc-RTOS

SW 마에스트로 과정에서 진행한 MPSoC 모바일 플랫폼 운영체제
간단한 커널의 개발 프로젝트다.

## 실시간 시스템(Real Time System)

제한시간 내 논리적으로 완벽하게 동작해야 하는 시스템
제한시간 내 동작하지 않을 경우 심각한 결과 발생

## Embedded RTOS의 특징

- Multitasking(멀티태스킹)
- Preemptive(선점)
- Deterministic(예측가능성)
- Portable(이식성)

## 구현된 기능 목록

- 개발 환경 구성 및 부트로더 제작
- 기본적인 C Library 작성
- 하드웨어 인터럽트 루틴의 설계와 구현
- 스케줄러 알고리즘 설계와 구현
- 동기화 설계 및 구현
- 멀티코어 OS로 변경 작업
- inter-Core Communication 지원
- Inter Task Communication 지원
- 우선순위 기반 스케줄링
- MultiCore환경 Interrupt Handling 지원
