# OLS Regression

- 2023-10-06 10:10-12:10
- Instructor: Christy Pu
- Course: Applied Econometrics for Health Policy

[toc]

## 快速回顧：關於研究的常見問題解答

1. 基於理論陳述感興趣的**因果關係** (State the **causal relationship** of interest, based on theory)
   - 一個實證研究最容易被人詬病的部分。這是這堂課的重點，不只是要說明有關連性，而是要證明是否有因果關係。
2. 設計假設性的**理想實驗**來驗證研究假設 (Design the hypothetical **ideal experiment** to test the hypothesis)
   - 必須要先幻想一個理想的實驗，雖然無法達成，但是透過這種想像，才能體會或理解到真實的實驗會具有哪些 bias 或限制。
3. 具體說明你的**識別策略**，例如：自然實驗 (Specify on your **identification strategy**, e.g. natural experiment)
   - 自然實驗：透過一個自然的事件，偶然造成的幾近隨機分派的事件。畢竟有很多研究難以通過 IRB。
4. 檢查你的**統計推論模型** (Check on your **mode of statistical inference**)

## Multiple Linear Regression

- 即「透過多個變數如 $x_1, x_2, \dots, x_k$ 來解釋變數 $y$」。
<img src="pic/p3.png" width="600">
