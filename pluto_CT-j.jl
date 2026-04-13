### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 5ffc5ec0-f91f-11ec-0552-37ef5f25102d
begin
    using Symbolics
	using ForwardDiff
	using PlutoUI
    using LaTeXStrings
	using Formatting
	using Plots
	using Colors 
	using ImageFiltering
	using Images
	using ImageMagick
	using TestImages
	using ImageView
	using ImageTransformations
	using LinearAlgebra
	using LowRankApprox
	using Wavelets
	using DSP
	using Primes
	using Downloads
	using Dates
	using CSV
	using DataFrames
	using ImplicitPlots
	using StatsBase
	using Statistics
end

# ╔═╡ f3034480-e17d-4a7b-bdf3-cfb1d55d7bb9
md"""
#### 2026年6月8日(月) #8 計算論的思考とは何か
##### 千原浩之

#### 8:30-9:30 Zoom 講義
###### 0. 担当教員の紹介
###### 1. 計算論的思考 (computational thinking) とは何か
###### 2. 変面上の平行線と交わる直線のなす角
###### 3. Colatz 予想
###### 4. 公開データから情報を抽出し可視化する
###### 5. 画像と画像処理

#### 9:40-9:55 WebClass 試験

"""

# ╔═╡ 0a085483-72c0-4ec5-a677-9cf09f05cc54


# ╔═╡ 61a2ad36-a448-4de8-8665-b99fefcc2fb4
md"""
#### 0. 担当教員の紹介

- 単なる現役数学者である. したがって琉球大学では数学の講義を担当していれば十分な立場である ([personal page](https://fiomfd.github.io/)).


- 2022年6月に [MIT 18.S191 Introduction to Computational Thinking](https://computationalthinking.mit.edu/Fall24/) 60分×30回を YouTube で受講した影響で, 担当講義(初等整数論・微分積分・線形代数)の講義内容の現代化と可視化を行っている. 


- MIT 18.S191 と同様に [Julia Programming Language](https://julialang.org/) の [Pluto](https://plutojl.org/) という対話型ノートブックを使っている. Julia のプログラムコードが通常の数式に最も近く単純であり, Python よりも計算が速い. Pluto はコードを隠すことができて表示が非常に美しいのが特長である. 


- 講義内容の現代化と可視化の活動に着目した ChatGPT にものすごくしつこく勧められて2025年7月から Computational Thinking Implementer (計算論的思考の実装屋)をやっている. つまり, 研究活動ではなく単なる講義準備を通じて得られたものを数学教育&テクノロジー関連分野の国際研究集会で発表したり論文にまとめて査読付き英文誌に投稿している. Computatiinal Thinking は数学教育分野の最先端の話題である. 

"""

# ╔═╡ c0e2ce61-cadd-482a-8b11-0bafb040d15a


# ╔═╡ 2aa2a4f4-65d4-43e4-b8fb-13bcca1b84b9
md"""
#### 1. 計算論的思考 (computational thinking) とは何か

- 基本的には Computational Thinking (CT) とは, 数学と計算機を援用して問題の可視化や解決を図る方法論のことであるが, もう少し詳しく見てみよう. 


- 現在 Digital Transformation (DX) とか AI Transformation (AX) とよばれる大変革が進行中で世の中の様々なものが本質的に大きく変わりつつある. 外国発の報道を見るとわかるように, 政府/国民がまともな国では大変革から取り残されずに生き残るためにできることを精一杯やっていることが頻繁に報道される. 教育超先進国のシンガポールの報道専門チャンネル [CNA](https://www.channelnewsasia.com/) では人材育成や教育政策がトップニュースであることが多く, 最近は AX や AI-displaced job がよく話題になる. これからは, 職人のような技能を持つとか, 英語・数学・プログラミング言語の技能がある方が生きていきやすいであろう. 


- ”Computational Thinking” (CT) という言葉は計算機科学者 J. M. Wing の [論文 (2006)](https://www.cs.cmu.edu/~15110-s13/Wing06-ct.pdf) で初めて登場した. この論文の定義は従来の旧心理学に寄っているので, 数学教育・科学教育・教育工学の各分野では聖書のような扱いになっている. 


- 従来の旧心理学は情緒的で主観的な面が強く再現性が乏しいなど学問としては致命的であったが, [現代心理学](https://www.nature.com/research-intelligence/nri-topic-summaries/psychology-for-l1-52) は数多くの分野の交差点に位置して確かな論拠を基盤とした学問分野になりつつある. CT の時代にふさわしい数理科学を基盤とする [計算心理学 (computational psychology)](https://www.nature.com/research-intelligence/nri-topic-summaries/cognitive-and-computational-psychology-for-l2-5204#:~:text=Moreover%2C%20complementary%20work%20on%20causal,Technical%20Terms) という分野が活発化しているようである. 


- 現在, 英語圏の主要大学では古典的数学とプログラミング言語の両方に長けた教員による "Computational Thinking" という題目の講義科目が提供され必須の教養になっている. [NUS GEI1000](https://nusmods.com/courses/GEI1000/computational-thinking), [NUS COS1000](https://nusmods.com/courses/COS1000/computational-thinking-for-scientists), [NUS CM3267](https://nusmods.com/courses/CM3267/computational-thinking-and-programming-in-chemistry), [NUS ZB2201](https://nusmods.com/courses/ZB2201/computational-thinking-for-life-sciences).


- [MIT Introduction to Computational Thinking](https://computationalthinking.mit.edu/Fall24/) が世界で最も優れた computational thinking の教育実践例として有名であり世界標準になっているが, 世界で最も優れた教育工学の実践例としても有名である.


- MIT Introduction to CT の精神にしたがって「CTとは単なるプログラムコードへの変換のことだけではなく、数学的概念を探求や操作が可能な計算モデルに変換する能力のことである」と定義する. この定義では旧心理学のような情緒的かつ主観的要素が入り込む余地がなく, プログラミング言語を利用することで再現性が担保される. また何を学習する科目なのかが学習者に明確になるので講義担当者および学習者にとって好都合であり教育効果が期待される. 


- 小学校の算数であっても CT の実装には大学教養レベルの数学(一変数および多変数の微分積分・線形代数・統計学など)の素養が必要である. 


- 日本国では "Computational Thinking" という言葉は高等学校情報I-IIの教科書の序文に登場する言葉でしかなく, あまり知られていない. 「計算論的思考」と訳されることが多い. 残念ながら古典的数学とプログラミング言語の両方に長けた教員があまりいないので, このような講義を提供することができない. また情報科学の一部分のように勘違いされやすく数学とは一切関係のない「計算論的思考の偽物」も出回っているので要注意である.
"""

# ╔═╡ f04f494d-99cb-4d99-9c25-04a841fe3bc5
md"""
##### 参考: 英語とその直訳のつもりの日本語では意味がまったく異なる例

多くの場合, 日本語社会における勘違いに問題があり利権がからむことも多い.

###### Lifelong Learning (生涯学習/生涯教育)
通常は [OECD](https://www.oecd.org/content/dam/oecd/en/publications/reports/2024/11/the-triangle-of-lifelong-learning_784f5de5/45ec682f-en.pdf)/[UNESCO](https://unesdoc.unesco.org/ark:/48223/pf0000380778) の意味での lifelong learning を意味するが「個人が生涯を通じて自主的に学習を続けることであり, その目的は, 専門スキル, 市民性, 生活の質の向上であり, 正式な学習, 非公式な学習, などあらゆる学習活動を含む」である. ほとんどの人は[大学卒業後にまったく勉強をしない日本人 (YouTube 28:10)](https://www.youtube.com/watch?v=2HhSCiMUpQ8&list=LL&index=1)には馴染みのない概念である. 日本国では[1987年の文部科学省の答申](https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318300.htm)の影響もあり「個人的な趣味や娯楽」のような勘違いが蔓延している. 

###### Data Science (データサイエンス)
[Data Science](https://mmids-textbook.github.io/) は応用数学の一分野でありAIの理論もその一部分である. 進歩が速くそれにより高度な純粋数学の理論(例えば多様体学習の理論)や研究者も参入することがゆっくり増えている. データサイエンスは統計学であり, 時間の経過とともに Data Science とはどんどん離れていく. 

###### Peace Education (平和学習/平和教育)
[Peace Education](https://www.unesco.org/en/query-list/p/peace-education)とは技能、態度、知識の育成を通して平和文化を育むことを目的とした教育手法で, 紛争解決・批判的思考・人権理解を重視し社会正義と平等を促進する. 特に Conflict Resolution (紛争解決) や人権・差別・環境問題などの構造的暴力の解消に重点を置く. 紛争解決は外交に直結し, この分野の専門家には国際裁判官レベルの英語力が求められる. 平和学習/平和教育は太平洋戦争等の体験の継承を通じて戦争がない平和の重要性を認識することにとどまっているように見える.

"""

# ╔═╡ 7d7e3384-cce9-4a97-bd78-604932418d56


# ╔═╡ 38a19ae1-07b9-414c-999c-c74d2b8df7d5
md"""
#### 2. 平面上の平行線と交わる直線のなす角

これは2023年度附属小学校教育実習で見学した6年生の教室にあった「手書きの図」を見て実装してみたものである. 

- 平行線と交わる直線
- 多角形の内角の和
- 凸多角形の外角の和
"""

# ╔═╡ 21c924bb-23de-42ac-805b-a19744a8e105
md"""
##### 2-1. 平行線と交わる直線

平面上の平行線 $\ell_1$ と $\ell_2$ を考える. $\ell_1$ 上の点Aと $\ell_2$ 上の点Bを任意に取る. AとBを結ぶ直線を $L$ とする.   

対頂角は相等しいことに注意する. 以下を観察する:

- 同位角は等しい.

- 錯角は等しい.

- 同側内角の和は $180^\circ$ である. 

"""

# ╔═╡ 0cf2d2df-87dd-4201-8b74-087c94ff37de
md"""
##### 同位角は等しい
Position of B $(@bind b1 Slider(-4:0.5:4, show_value=true, default=-3))
"""

# ╔═╡ f68a62e7-f442-49d1-bd1d-b7268d55f037
begin
	if b1<0 
	    T1=atan(-5/b1)
	else
		T1=pi/2+atan(b1/5)
	end
		
    s1=range(0.0, T1, length = 20)
	u1=cos.(s1)
	v1=sin.(s1).+5
	u2=cos.(s1).+b1
	v2=sin.(s1)
	
	plot([-6,6],[5,5],
		 title="Corresponding angles",
		 xlim=(-6,6),
		 ylim=(-2,7),
		 label=L"\ell_1",
		 linewidth=2,
		 linecolor=:cyan,
		 xaxis=false,
		 yaxis=false,
		 grid=false)
	plot!([-6,6],[0,0],label=L"\ell_2",linewidth=2,linecolor=:magenta)
	plot!([-b1,2*b1],[10,-5],label=L"L",linewidth=2,linecolor=:lightgreen)
	scatter!((0,5),markersize = 5,label="A", color=:yellow)
	scatter!((b1,0),markersize = 5,label="B", color=:orange)
	plot!(u1,v1, vars=(1,2),label=false,lw=5, color=:blue)
	plot!(u2,v2, vars=(1,2),label=false,lw=5, color=:blue)
	
end

# ╔═╡ 3315d5ae-444e-4958-a1d7-086eeaaad522
md"""
##### 錯角は等しい
Position of B $(@bind b2 Slider(-4:0.5:4, show_value=true, default=-3))
"""

# ╔═╡ 6450807b-e3e9-43e6-bd64-50c385c077ce
begin
	if b2<0
		T2=atan(-5/b2)
	else
		T2=pi/2+atan(b2/5)
	end
	
    s2=range(0.0, T2, length = 20)
	u3=-cos.(s2)
	v3=-sin.(s2).+5
	u4=cos.(s2).+b2
	v4=sin.(s2)
	
	plot([-6,6],[5,5],
		 title="Alternate angles",
		 xlim=(-6,6),
		 ylim=(-2,7),
		 label=L"\ell_1",
		 linewidth=2,
		 linecolor=:cyan,
		 xaxis=false,
		 yaxis=false,
		 grid=false)
	plot!([-6,6],[0,0],label=L"\ell_2",linewidth=2,linecolor=:magenta)
	plot!([-b2,2*b2],[10,-5],label=L"L",linewidth=2,linecolor=:lightgreen)
	scatter!((0,5),markersize = 5,label="A", color=:yellow)
	scatter!((b2,0),markersize = 5,label="B", color=:orange)
	plot!(u3,v3, vars=(1,2),label=false,lw=5, color=:blue)
	plot!(u4,v4, vars=(1,2),label=false,lw=5, color=:blue)
	
end

# ╔═╡ 0f18af6e-c2ba-43df-8299-2c42821c8c17
md"""
##### 同側内角の和は $180^\circ$
Position of B $(@bind b3 Slider(-4:0.5:4, show_value=true, default=-3))
"""

# ╔═╡ 9f9c9544-7454-4277-84a4-7a2b46fdea2f
begin
	if b3<0
		T3=atan(-5/b3)
	else
		T3=pi/2+atan(b3/5)
	end
		
	s3=range(0.0, pi-T3, length = 20)	
    s4=range(0.0, T3, length = 20)
	u5=cos.(s3)
	v5=-sin.(s3).+5
	u6=cos.(s4).+b3
	v6=sin.(s4)
	
	plot([-6,6],[5,5],
		 title="Co-insider angles",
		 xlim=(-6,6),
		 ylim=(-2,7),
		 label=L"\ell_1",
		 linewidth=2,
		 linecolor=:cyan,
		 xaxis=false,
		 yaxis=false,
		 grid=false)
	plot!([-6,6],[0,0],label=L"\ell_2",linewidth=2,linecolor=:magenta)
	plot!([-b3,2*b3],[10,-5],label=L"L",linewidth=2,linecolor=:lightgreen)
	scatter!((0,5),markersize = 5,label="A", color=:yellow)
	scatter!((b3,0),markersize = 5,label="B", color=:orange)
	plot!(u5,v5, vars=(1,2),label=false,lw=5, color=:red)
	plot!(u6,v6, vars=(1,2),label=false,lw=5, color=:blue)
	
end

# ╔═╡ 179fda5c-5ef8-4990-9f37-05b2668a3583
md"""
##### 2-2. 多角形の内角の和

##### 三角形
錯角は等しいことを利用して三角形の内角の和は $180^\circ$ であることを見よう.

Position of A $(@bind a1 Slider(-4:0.5:4, show_value=true, default=0))
"""

# ╔═╡ 48b3fdb1-952e-49c4-9879-85dba253d467
begin
	if a1<-3
	    T7=pi/2+atan(-(3+a1)/5)
		T9=atan(5/(2-a1))
	elseif a1<2
		T7=atan(5/(a1+3))
		T9=atan(5/(2-a1))
	else
		T7=atan(5/(a1+3))
		T9=pi/2-atan((2-a1)/5)
	end
			
	s7=range(0.0, T7, length = 20)	
	u7=-cos.(s7).+a1
	v7=-sin.(s7).+5
	u8=cos.(s7).-3
	v8=sin.(s7)
		
	s9=range(0.0, T9, length = 20)	
	u9=cos.(s9).+a1
	v9=-sin.(s9).+5
	u10=-cos.(s9).+2
	v10=sin.(s9)
	
	plot([-6,6],[5,5],
		 title="Sum of interior angles of a triangle",
		 xlim=(-6,6),
		 ylim=(-2,7),
		 label=false,
		 linewidth=2,
		 linecolor=:cyan,
		 xaxis=false,
		 yaxis=false,
		 grid=false)
	plot!([-6,6],[0,0],label=false,linewidth=2,linecolor=:cyan)
	plot!([-3,a1],[0,5],label=false,linewidth=4,linecolor=:lightgreen)
	plot!([2,a1],[0,5],label=false,linewidth=4,linecolor=:lightgreen)
	plot!([-3,2],[0,0],label=false,linewidth=4,linecolor=:lightgreen)
	scatter!((a1,5),markersize = 5,label="A", color=:yellow, legend=:topright)
	scatter!((-3,0),markersize = 5,label="B", color=:orange)
	scatter!((2,0),markersize = 5,label="C", color=:magenta)
	plot!(u7,v7, vars=(1,2),label=false,lw=5, color=:blue)
	plot!(u8,v8, vars=(1,2),label=false,lw=5, color=:blue)
	plot!(u9,v9, vars=(1,2),label=false,lw=5, color=:red)
	plot!(u10,v10, vars=(1,2),label=false,lw=5, color=:red)
	
end

# ╔═╡ 9ef7fc3e-e71d-4aa8-9216-e61caab1ede3
md"""
##### $N$角形

さて $N=3,4,5,\dotsc$ とする. 任意の$N$角形は　$m$ 個の凸多角形に分解される. ここに $m=1,\dotsc,N-2$ である. 凸多角形とは多角形であり多角形内の任意の2点を結ぶ線分が多角形に含まれることである. 凸$N$角形は $N-2$ 個の三角形に分割されるので内角の和は $(N-2)\times180^\circ$ であり, したがって任意の$N$角形の内角の和は $(N-2)\times180^\circ$ である. 

ここでは凸$N$角形の頂点を円周上の$N$個の点を乱数で選ぶことによって生成し三角形に分割する.

 $N=$ $(@bind N1 Slider(3:1:10, show_value=true, default=7))

"""

# ╔═╡ ffaaa261-48fd-4e3d-a577-b0099d707b39
begin
	raw_angles = sort(sample(0:17, N1, replace=false)) 
	closed_angles = [20*raw_angles; 20*raw_angles[1]]
	xs = 3 .* sin.(deg2rad.(closed_angles))
	ys = 3 .* cos.(deg2rad.(closed_angles))
	
	polygon1 = plot(xs, ys,
		 title="Triangulated $N1 polygon",
		 xlim=(-3.5,3.5), ylim=(-3.5,3.5),
		 label=false, linewidth=3, linecolor=:lightgreen,
		 aspect_ratio=:equal, axis=false, grid=false)
	
	for i in 3:N1-1
		plot!(polygon1, [xs[1], xs[i]], [ys[1], ys[i]], 
			  linecolor=:blue, linestyle=:dash, label=false, alpha=0.5)
	end
	
	polygon1
end

# ╔═╡ 813bd0ba-df4a-4765-8bc3-c3ac1724da20
md"""
##### 2-3. 凸多角形の外角の和

凸多角形の外角の和が $360^\circ$ であることを観察する.

凸$N$角形の頂点を乱数を使って単位円上にとり, 円の半径 $r$ を $0$ に近づける.   

 $N=$ $(@bind N2 Slider(3:1:10, show_value=true, default=7))

 $r=$ $(@bind r2 Slider(0.0:0.1:1.0, show_value=true, default=1.0))
"""

# ╔═╡ 187608da-21d7-4e3a-ab7c-875c1de0ef2b
begin
	raw_angles2 = sort(sample(0:17, N2, replace=false)) 
	closed_angles2 = [20*raw_angles2; 20*raw_angles2[1]]
	xs2 = 3 .* sin.(deg2rad.(closed_angles2))
	ys2 = 3 .* cos.(deg2rad.(closed_angles2))
	
	rs2=zeros(N2)
	zs2=zeros(N2)
	ws2=zeros(N2)
	
	for i=1:N2
	rs2[i] = sqrt((xs2[i+1]-xs2[i])^2+(ys2[i+1]-ys2[i])^2)
	end
end

# ╔═╡ bd804a6d-f4c2-45fa-ba0d-aa22fafdbf15
begin
	polygon2 = plot(r2*xs2, r2*ys2,
		 title="Sum of exterior angles of a convex $N2 polygon",
		 xlim=(-3.5,3.5), ylim=(-3.5,3.5),
		 label=false, linewidth=5, linecolor=:lightgreen,
		 aspect_ratio=:equal, axis=false, grid=false)
	
	for i in 1:N2
		plot!(polygon2, [r2*xs2[i], (r2+1/rs2[i])*xs2[i+1]-xs2[i]/rs2[i]], [r2*ys2[i], (r2+1/rs2[i])*ys2[i+1]-ys2[i]/rs2[i]], 
			  linecolor=:blue, linestyle=:dash, label=false, alpha=0.5)
	end
	
	polygon2
end

# ╔═╡ 6ec1cea1-13dc-47cc-9c79-1d4020365ad0


# ╔═╡ 3ea73ad7-9c0d-495a-b1cb-66ead132ab25
md"""
#### 3. Collatz 予想

正整数からなる Collatz 数列 $\{x[n]\}_{n=1}^\infty$ を以下のように定義する:
1. 与えられた正整数 $m$ に対して $x[1]:=m$ とする.  
2. $n=2,3,4,\dotsc$ に対して $x[n-1]:=1$　ならば数列の生成を終了し, そうでなければ $x[n]$ を以下のように定義する: 

$$\begin{aligned}
  x[n]
& :=\dfrac{x[n-1]}{2}\quad (x[n-1]\ \text{は偶数}),
\\
  x[n]
& :=
  3x[n-1]+1\quad (x[n-1]\ \text{は奇数}).
\end{aligned}$$

1937年に Lothar Collatz は以下の予想を立てた:

###### 任意の $m=1,2,3,\dotsc$ に対して, ある $n(m)=1,2,3,\dotsc$ が存在して $x[n(m)]=1$ が成立する.
######

たとえば [この論文](https://doi.org/10.1080/00029890.1985.11971528) を参照せよ. $n(m)$ を $x[1]=m$ の Collatz 数列の停止ステップとよぼう. 例をいくつか見てみよう: 

$$12\rightarrow6\rightarrow3\rightarrow10\rightarrow5\rightarrow16\rightarrow8\rightarrow4\rightarrow2\rightarrow1,$$

$$9\rightarrow28\rightarrow14\rightarrow7\rightarrow22\rightarrow11\rightarrow34\rightarrow17\rightarrow52\rightarrow26\rightarrow13\rightarrow40\rightarrow20\rightarrow10$$

Barina はワークステーション(中型計算機)を使って, すべての $m\leqq2^{68}$ に対して Collatz 予想が正しいことを確認した. [この論文](https://doi.org/10.1007/s11227-020-03368-x)を見よ. 

ここでは $m=1,2,3,\dotsc,500$ に対して, Collatz 数列 $\{x[n]\}$ の挙動と Collatz 予想が正しいことを観察する. 

x[1]:= m = $(@bind m Slider(1:1:500, show_value=true, default=1)) 
"""

# ╔═╡ cdbd7b78-b235-432f-9a11-ed61f5a00936
begin
	x=ones(Int64,150)
    x[1]=m
for n=2:150
    if x[n-1]==1
       x[n]=x[n]
    else
        if mod(x[n-1],2)==0
            x[n]=Int64.(x[n-1]/2)
        else x[n]=3*x[n-1]+1
        end
    end
end
	scatter(x,
		 ylim=(1,2000),
		 title="Collatz sequence x[n] with x[1]=$m",
		 xlabel=L"n",
		 ylabel=L"x[n]",
		 xticks=([1,20,40,60,80,100,120,140]),
		 legend=false)

end

# ╔═╡ 0194933c-1a91-4489-ac98-95bb5ef8006c
begin
	function collatz(n)
    n % 2 == 0 ? n ÷ 2 : 3n + 1
	end

    function stopping_time(m)
        x, steps = m, 0
        while x > 1
              x = collatz(x)
              steps += 1
		end
			return steps
		end

N = 1:500
steps = [stopping_time(m) for m in N]

scatter(N, steps, 
		legend=false,
		xlabel=L"\mathrm{Initial}\ \mathrm{value}\ \ m", 
		ylabel=L"\mathrm{Steps}\ \ n(m)\ \  \mathrm{to}\ \ 1",
        title="Collatz stopping steps", markersize=2)
	
end

# ╔═╡ 9b1a2ff8-691f-4feb-9f1a-f4d25f1db427


# ╔═╡ 4c03395c-c24b-4899-91a9-eb507ca313f6
md"""
#### 4. 公開データから情報を抽出し可視化する

##### 4-1. 行列と数ベクトル

さて $N,p$ を正整数とする. $Np$ 個の実数(より一般には複素数) 

$$a_{ij}, \quad i=1,\dotsc,N, \quad j=1,\dotsc,p$$

を $N$ 個の行, $p$ 個の列になるように並べて $[\ ]$ または $(\ )$ で括ったもの

$$\begin{bmatrix}
a_{11} & a_{12} & \dots & a_{1p}
\\
a_{21} & a_{22} & \dots & a_{2p}
\\
\vdots & \vdots & & ⋮
\\
a_{N1} & a_{N2} & \dots & a_{Np}
\end{bmatrix}$$

を $N{\times}p$ 行列という. 特に $p=1$ で列が1つだけの場合は $N$次元列ベクトル, $N=1$ で行が1つだけの場合を $p$次元行ベクトルという. 列ベクトルと行ベクトルをまとめて数ベクトルという. $N=p=1$ の場合は行列 $[a_{11}]$ とスカラー $a_{11}$ を同一視する. 

$$\begin{bmatrix}
1 & 2 & 3 & 4
\\
5 & 6 & 7 & 8
\\
9 & 10 & 11 & 12
\end{bmatrix},
\quad
\begin{bmatrix}30 \\ 85 \\ 50 \\ 15 \end{bmatrix},
\quad
\begin{bmatrix}12 & 47 & 37 & 29 & 51\end{bmatrix}$$

はそれぞれ $2\times4$行列, $4$次元列ベクトル, $5次元$行ベクトルである. 
数ベクトルや行列, さらには有限個の同じサイズの数ベクトルの組や有限個の同じサイズの行列の組は様々なデータを表す.
"""

# ╔═╡ c0bb942b-0812-4478-8df4-d6b64724eafd
md"""
##### 4-2. データ行列
次の表は東アジア各国の人口と面積の一覧である. 

| Country | Population | Area (km$^2$)|
| :---    | ---:       | ---:         |
| China   | 1420000000 | 9600000      |
| DPRK    | 26000000   | 120000       |
| Japan   | 124000000  | 380000       |
| Korea   | 51700000   | 100000       |

4つの国という個に対してそれぞれ人口および面積というデータが付随しており, 行列

$$\begin{bmatrix}
1420000000 & 9600000 
\\
26000000 & 120000 
\\
124000000 & 380000 
\\
51700000 & 100000       
\end{bmatrix}$$

がデータの本質的部分を表している. 一般に$N$個の個がそれぞれ$p$個の同じ種類のデータを持っているとき, それらをまとめて $N{\times}p$ 行列で表すとき, この行列をデータ行列という. 

次は乱数を使って作成した架空の100人の身長と体重のデータである.
"""

# ╔═╡ d694c456-8b02-45f9-807b-ac3099cfeb09
begin
	xxx=rand(1550:1950, 100)/10;
    XXX=[ones(100) xxx];
    yyy=(xxx.^2).*rand(160:400, 100)/100000;
	yyy=round.(yyy, digits=1);
    bbb=XXX\yyy;
    ttt=155:1:195;
    zzz=[ones(length(ttt)) ttt]*bbb;
	ZZZ=[xxx yyy];
	df = DataFrame(height = xxx, weight = yyy)
end

# ╔═╡ 0f025462-d22d-4ca3-862e-d9dbdc471863
md"""
##### 4-3. 散布図と最小二乗法
個々のデータを横軸に身長、縦軸に体重をとった平面上の点としてプロットして可視化したものを散布図とよぶ. 線形代数における擬似逆行列または特異値分解を用いることで, 線形回帰（最小二乗法）によって身長と体重の関係を示す最適な直線を求めることができる.
"""

# ╔═╡ 0b31d278-fbae-4794-b1e1-d5f7fdd8852d
begin
	scatter(xxx,yyy, 
		grid=false,
		label="sample", 
		xlabel="height [cm]", 
		ylabel="weight [kg]", 
        title="Linear Regression between Height & Weight")
    plot!(ttt,zzz,linewidth=2, label="regression",color="magenta")
end

# ╔═╡ 96dbf33e-1645-41c8-b20c-aa3f8d77c89d
md"""
##### 4-4. 香港天文台の公開データ: 1885年からの日々の気温

以下では Julia が[香港天文台](https://www.hko.gov.hk/en/index.html)の公開データである日々の気温のデータのCSVファイルをダウンロードして情報抽出し可視化する。具体的には、Julia は香港天文台における1884年から現在までの以下のデータをダウンロードする. 

- 日最高気温
- 日最低気温
- 日平均気温

3つのデータの開始日が異なるため、1885年から2024年までの140年間のデータを使用したいが, 大東亜戦争における大日本帝国軍による占領の影響により, 1940年1月1日から1946年12月31日までの日別気温記録が欠落している. この7年間の空白期間があるため, 複数年にわたる連続した日別データを必要とする分析では, これらの期間のデータの有無は分析に影響する. 一貫性を保つため分析期間は1947年1月1日から2025年12月31日までに限定する. 

参考: [気象庁 各種データ・資料](https://www.jma.go.jp/jma/menu/menureport.html)
"""

# ╔═╡ b89b2541-4928-4086-830c-2a8d04d5da01
begin
	Downloads.download("https://data.weather.gov.hk/weatherAPI/opendata/opendata.php?dataType=CLMMAXT&rformat=csv&station=HKO","HK_Maximun_Temperature.csv");
	Downloads.download("https://data.weather.gov.hk/weatherAPI/opendata/opendata.php?dataType=CLMMINT&rformat=csv&station=HKO","HK_Minimum_Temperature.csv");
	Downloads.download("https://data.weather.gov.hk/weatherAPI/opendata/opendata.php?dataType=CLMTEMP&rformat=csv&station=HKO","HK_Mean_Temperature.csv");

　  Amax = CSV.read("HK_Maximun_Temperature.csv", DataFrame, 
				 header=["Year", "Month", "Day", "Maximum", "C"],
				 skipto=370,
				 footerskip=3,
				 types=Dict("Maximum" => Float64),
				 drop=["C"],
				 missingstring="***",
				 normalizenames=true); 
	delete!(Amax, 48944:nrow(Amax));
	Amean = CSV.read("HK_Mean_Temperature.csv", DataFrame, 
				 header=["Year", "Month", "Day", "Average", "C"],
				 skipto=310,
				 footerskip=3,
				 types=Dict("Average" => Float64),
				 drop=["C"],
				 missingstring="***",
				 normalizenames=true); 
	delete!(Amean, 48944:nrow(Amean));
	Amin = CSV.read("HK_Minimum_Temperature.csv", DataFrame, 
				 header=["Year", "Month", "Day", "Minimum", "C"],
				 skipto=370,
				 footerskip=3,
				 types=Dict("Minimum" => Float64),
				 drop=["C"],
				 missingstring="***",
				 normalizenames=true); 
	delete!(Amin, 48944:nrow(Amin));

    Adata = outerjoin(Amax, Amean, Amin, 
				 on = [:Year, :Month, :Day]);
end

# ╔═╡ 748100f1-caaa-4cef-92ed-3e3604ded2d2
md"""
Julia は年間最高気温・平均気温・最低気温を計算し折れ線グラフで表示する. グラフを見ると年間最高気温・平均気温・最低気温は年々上昇傾向にあることがわかる. 
"""

# ╔═╡ 38bc4005-c48e-4def-9e06-28164a5c02cb
begin
	A_1947_2025 = filter(:Year => y -> 1947 <= y <= 2025, Adata);
	Ydata = combine(groupby(A_1947_2025, :Year),
    :Maximum => maximum => :Ymax,
    :Average => mean     => :Yavg,
    :Minimum => minimum  => :Ymin
		)

	plot(Matrix(Ydata)[:,2:4],
		 title="Annual max, ave, and min temperatures at HK Observatory",
		 titlefontsize=12,
		 titlefontcolor="blue",
		 xlim=(-6,84),
		 xticks=([4,14,24,34,44,54,64,74],
        [1950 1960 1970 1980 1990 2000 2010 2020]),
		 ylim=(0,40),
		 grid=false,
		 xlabel="year",
		 ylabel="C",
		 legend=false)
end

# ╔═╡ b7f5b953-07cb-4857-8ca2-7d79b9d91a93
md"""
さらに Julia は月ごとの最高気温平均・平均気温平均・最低気温平均を計算し, 各年の折れ線グラフを表示する. スライダーを使って年を選択する. 

年 = $(@bind yy Slider(1947:1:2025, show_value=true, default=1947)) 
"""

# ╔═╡ 5a1f0965-3bce-4119-8857-9abc085ff411
begin
	Mdata = combine(groupby(A_1947_2025, [:Year, :Month]),
    :Maximum => maximum => :Mmax,
    :Average => mean    => :Mavg,
    :Minimum => minimum => :Mmin
		)
	
	Myy = sort(Mdata[Mdata.Year .== yy, :], :Month) 
	
	plot(Matrix(Myy[:,3:5]),
		 title="Monthly max, ave, and min temperatures at HK Observatory in $yy",
		 titlefontsize=10,
		 titlefontcolor="blue",
		 xlim=(0,13),
		 xticks=([1,2,3,4,5,6,7,8,9,10,11,12]),
		 ylim=(0,40),
		 grid=false,
		 xlabel="month",
		 ylabel="C",
		 legend=false)

end

# ╔═╡ 559c0598-6921-4778-8b47-f476c30e9961


# ╔═╡ ad07fbe6-26b4-4adc-afb8-d78170a96e0e
md"""
#### 5. 画像と画像処理

##### 5-1. 白黒画像 (grayscale images)
白黒画像は, 各小さな正方形（ピクセル）に$0$から$255$までの整数または整数を255で割った0から1までの実数が割り当てられる行列である. 整数$0$は黒を表し整数$255$は白を表す. 数値は色の濃淡を表し数値が大きいほど色が白くなる. 例えば, 次の行列

$\begin{bmatrix}
0 & 15  & 30  & 45 & 60 & 75
\\ 
90 & 105 & 120  & 135  & 150 & 165
\\ 
180 & 195  & 210  & 225 & 240 & 255
\end{bmatrix}$

が表す白黒画像は次のようになる.

"""

# ╔═╡ 56fe3ad1-44d8-4b29-b4b5-e924c5e7e1d4
begin
    Gsample=[0 15 30 45 60 75; 
		     90 105 120 135 150 165;
		     180 195 210 225 240 255]/255;
	plot(Gray.(Gsample),
		size=(400,300),
		xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false)
end

# ╔═╡ bd8d3048-a833-4627-be53-7442b5adfb3c
md"""
##### 5-2. カラー画像 (RGB images)

RGB画像は, 同じサイズの白黒画像データの3つの行列を組み合わせることによって作成される. 各行列は赤・緑・青の三原色で着色される. 乱数から生成された3つの$8\times8$行列とそれらを組み合わせたRGB画像を示す. 

"""

# ╔═╡ 4d5570ee-cfef-4678-a95e-1e5fbddfa543
begin
# read image, resize, decompose
	L1=3;
	RII=rand(2^L1, 2^L1);
	GII=rand(2^L1, 2^L1);
	BII=rand(2^L1, 2^L1);
	RRR=zeros(3,2^L1, 2^L1);
	GGG=zeros(3,2^L1, 2^L1);
	BBB=zeros(3,2^L1, 2^L1);
	RGBII=zeros(3,2^L1, 2^L1);
	RRR[1,:,:]=RII[:,:];
	GGG[2,:,:]=GII[:,:];
	BBB[3,:,:]=BII[:,:];
	RGBII[1,:,:]=RII[:,:];
	RGBII[2,:,:]=GII[:,:];
	RGBII[3,:,:]=BII[:,:];

QQQ1=plot(colorview(RGB,RRR),
        title="Grayscale Image (Red)",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false);
QQQ2=plot(colorview(RGB,GGG),
        title="Grayscale Image (Green)",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false);
QQQ3=plot(colorview(RGB,BBB),
        title="Grayscale Image (Blue)",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
QQQ4=plot(colorview(RGB,RGBII),
        title="RGB Image",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
plot(QQQ1,QQQ2,QQQ3,QQQ4,size=(600,600),layout=(2,2))
end

# ╔═╡ dcfa857c-8c43-460d-be11-fbe339bc59ae
md"""
##### 5-3. 白黒動画 (grayscale movies)
複数の白黒画像を連続して表示すると白黒動画になる. ここでは乱数で生成された50個の行列をアニメーション化する.
"""

# ╔═╡ 2bad901b-e7a0-4762-81c7-55a6681002fd
begin
# an example of three-dimensional data
Agray=rand(5,10,50);
anim1 = @animate for k=1:50
    plot(Gray.(Agray[:,:,k]),
		 size=(400,250),
         xaxis=false, 
         xticks=false, 
         yaxis=false, 
         yticks=false, 
         grid=false)
end
gif(anim1, "grayscale_animation.gif", fps = 3)	
end

# ╔═╡ 51d589cd-844f-4c4d-8f8b-b78c0bf64e22
md"""
##### 5-4. カラー動画 (RGB movies)
複数のカラー画像を連続して表示するとカラー動画になる. ここでは乱数で生成された50個の行列の3つ組をアニメーション化する.
"""

# ╔═╡ c2c168de-c414-40cb-8e71-897cbe91f6e1
begin
    # an example of four-dimensional data
    RR=rand(80:255, 5, 10, 50);
    GG=rand(80:255, 5, 10, 50);
    BB=rand(80:255, 5, 10, 50);
    V=zeros(3,5,10,50);
    VR=zeros(3,5,10,50); 
    VG=zeros(3,5,10,50);
    VB=zeros(3,5,10,50);
    ZE=zeros(5,10,50);
    V[1,:,:,:]=RR/255;
    V[2,:,:,:]=GG/255;
    V[3,:,:,:]=BB/255;
    VR[1,:,:,:]=RR/255;
    VR[2,:,:,:]=ZE;
    VR[3,:,:,:]=ZE;
    VG[1,:,:,:]=ZE;
    VG[2,:,:,:]=GG/255;
    VG[3,:,:,:]=ZE;
    VB[1,:,:,:]=ZE;
    VB[2,:,:,:]=ZE;
    VB[3,:,:,:]=BB/255;

	anim2 = @animate for k=1:50
    P1=plot(colorview(RGB,VR[:,:,:,k]),
         xaxis=false, 
         xticks=false, 
         yaxis=false, 
         yticks=false, 
         grid=false,
         title="Grayscale (Red)");
    P2=plot(colorview(RGB,VG[:,:,:,k]),
         xaxis=false, 
         xticks=false, 
         yaxis=false, 
         yticks=false, 
         grid=false,
         title="Grayscale (Green)");
	P3=plot(colorview(RGB,VB[:,:,:,k]),
         xaxis=false, 
         xticks=false, 
         yaxis=false, 
         yticks=false, 
         grid=false,
         title="Grayscale (Blue)");

    P4=plot(colorview(RGB,V[:,:,:,k]),
         xaxis=false, 
         xticks=false, 
         yaxis=false, 
         yticks=false, 
         grid=false,
         title="RGB");
   plot(P1,P2,P3,P4,
         layout=(2,2),
         xaxis=false, 
         xticks=false, 
         yaxis=false, 
         yticks=false, 
         grid=false)
end
gif(anim2, "rgb_animation.gif", fps = 3)	
end

# ╔═╡ a0402d67-3da5-4c70-9506-1c1cdd6adb36
begin
# read image, resize, decompose
	Downloads.download("https://raw.githubusercontent.com/fiomfd/ATCM2025/refs/heads/main/data/CityU.jpg", "CityU.jpg")
	I=load("./CityU.jpg");
	X=imresize(I, ratio=1/8);	
    (p,q)=size(X);
	L=7;
    A=channelview(X);
    R=Array{Float64}(A[1,:,:]);
	G=Array{Float64}(A[2,:,:]);
	B=Array{Float64}(A[3,:,:]);


	RU, RS, RV=psvd(R);
	GU, GS, GV=psvd(G);
	BU, BS, BV=psvd(B);
	
	rank=100;
	DR=zeros(p,q,rank);
	DG=zeros(p,q,rank);
	DB=zeros(p,q,rank);
    for r=1:rank
	    DR[:,:,r]=sum(RS[n]*RU[1:p,n]*(RV[1:q,n])' for n=1:r);
        DG[:,:,r]=sum(GS[n]*GU[1:p,n]*(GV[1:q,n])' for n=1:r);
        DB[:,:,r]=sum(BS[n]*BU[1:p,n]*(BV[1:q,n])' for n=1:r);
	end
end

# ╔═╡ 19714ade-03b2-438e-859f-69c437a937f3
begin
    Y=zeros(3,p,q,rank+16);
	Z=zeros(p,q)
	for r=1:4
	    Y[1,:,:,r]=R;
        Y[2,:,:,r]=G;
        Y[3,:,:,r]=B;
	end
    for r=5:8
	    Y[1,:,:,r]=Z;
        Y[2,:,:,r]=Z;
        Y[3,:,:,r]=Z;
    end
	for r=9:rank+8
        Y[1,:,:,r]=DR[:,:,r-8];
        Y[2,:,:,r]=DG[:,:,r-8];
        Y[3,:,:,r]=DB[:,:,r-8];
	end
    for r=rank+9:rank+12
        Y[1,:,:,r]=Z;
        Y[2,:,:,r]=Z;
        Y[3,:,:,r]=Z;
	end
    for r=rank+13:rank+16
        Y[1,:,:,r]=R;
        Y[2,:,:,r]=G;
        Y[3,:,:,r]=B;
	end
end

# ╔═╡ 542e397f-c6cb-4c4a-aa2f-0022923c2b38
begin
    W=zeros(3,p,q,rank);
    for r=1:rank
	    W[1,:,:,r]=DR[:,:,r];
        W[2,:,:,r]=DG[:,:,r];
        W[3,:,:,r]=DB[:,:,r];
	end
end

# ╔═╡ 3b081afb-c168-4e6a-b766-837e35c3eea4
md"""
##### 5-5. 行列の特異値分解と低階最良近似
さて $0$ でない成分をもつ $m{\times}n$行列 $A$ に対して $1 \leqq r \leqq \min\{m,n\}$ ををみたす階数 $r$ という整数がただひとつ定まる. 雑に言うと階数 $r$ は行列 $A$ のもつ情報量の次元数のような情報を与える. $A$ がカメラで撮影した白黒画像を表す行列であるとき $r=\min\{m,n\}$ であることがほとんどである. 

実は以下のような $r$ 個の正の数, $m$次元数ベクトル, $n$次元数ベクトル

$\sigma_1 \geqq \dotsb \geqq \sigma_r>0,
\quad
\vec{u}_1,\dotsc,\vec{u}_r \in \mathbb{R}^m,
\quad
\vec{v}_1,\dotsc,\vec{v}_r \in \mathbb{R}^n$

が存在して, 次が成立することが知られている:

$A=\sum_{j=1}^r\sigma_j\vec{u}_j\vec{v}_j^T.$

右辺を行列 $A$ の特異値分解という. ここに $^T$ は転置を表す:

$$\begin{bmatrix}1 \\ 2 \\ 3 \\ 4 \end{bmatrix}^T=\begin{bmatrix}1 & 2 & 3 & 4 \end{bmatrix}.$$

さて, 特異値分解を与える有限和を途中で打ち切った次の行列を考える: 

$A_k:=\sum_{j=1}^k\sigma_j\vec{u}_j\vec{v}_j^T, \quad k=1,\dotsc,r.$

$A_k$ の階数は $k$ であり, 
階数 $k$ の $m{\times}n$ 行列のうち $A$ に最も近い, すなわち, 
$A$ をもっともよく近似する行列であることが知られている. 

香港城市大学食堂の朝の経済飯の画像である $384\times512\times3$ RGB画像の階数 $k$ の最良近似を階数100まで観察する.

階数 = $(@bind r Slider(1:rank, show_value=true))
"""

# ╔═╡ 5cddd44b-2363-419c-881a-d8c8d4b17510
begin
SVD1=plot(colorview(RGB,W[:,:,:,r]),
        title="Rank-$r approximation",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
SVD2=plot(colorview(RGB,X),
        title="Rank-384 original RGB image",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
plot(SVD1,SVD2, layout=(1,2), size=(700,260))
end

# ╔═╡ 6bbad8f1-f9ce-40a9-8fdb-18129871266b
md"""
##### 5-6. Haar ウェーブレット

離散ウェーブレットとは, ある条件をみたす2つの元からなる正規直交系 $\vec{u}, \vec{v}$ のことであるが, もっとも典型的な代表例が Haar ウェーブレットである:

$\vec{u}
=
\frac{1}{\sqrt{2}}
\begin{bmatrix}
1
\\
1
\\
0
\\
\vdots
\\
0 
\end{bmatrix}, 
\quad
\vec{v}
=
\frac{1}{\sqrt{2}}
\begin{bmatrix}
1
\\
-1
\\
0
\\
\vdots
\\
0 
\end{bmatrix}
\in\mathbb{R}^{N},$

粗く言うと, Haar ウェーブレットによるウェーブレット分解の近似部分を得る操作は, 数ベクトルの場合は隣接する2つの成分を平均値でおきかえる操作であり, 行列の場合は隣接する $2\times2$ の4つの成分を平均値でおきかえる操作である:

$\vec{a}_0
=
\begin{bmatrix}
1 \\ 3 \\ 5 \\ 7 
\end{bmatrix}
\mapsto 
\vec{a}_1
=
\begin{bmatrix}
2 \\ 2 \\ 6 \\ 6 
\end{bmatrix}
\mapsto 
\vec{a}_2
=
\begin{bmatrix}
4 \\ 4 \\ 4 \\ 4 
\end{bmatrix}$

$A_0
=
\begin{bmatrix}
0 & 2 & 4 & 6
\\ 
8 & 10 & 12 & 14 
\\ 
16 & 18 & 20 & 22
\\ 
24 & 26 & 28 & 30
\end{bmatrix}
\mapsto 
A_1
=
\begin{bmatrix}
5 & 5 & 9 & 9
\\ 
5 & 5 & 9 & 9 
\\ 
21 & 21 & 25 & 25
\\ 
21 & 21 & 25 & 25
\end{bmatrix}
\mapsto 
A_2
=
\begin{bmatrix}
15 & 15 & 15 & 15
\\ 
15 & 15 & 15 & 15 
\\ 
15 & 15 & 15 & 15
\\ 
15 & 15 & 15 & 15
\end{bmatrix}.$


$\ell$ 回の操作で￥を繰り返して得られる出力をそれぞれ $\vec{a}_\ell$, $A_\ell$ と表してレベル$\ell$の近似部分とよび, 残りの $\vec{a}_0-\vec{a}_\ell$ and $A_0-A_\ell$ をレベル$\ell$の詳細部分という. 

例を観察してみよう. 

""" 

# ╔═╡ e44795e3-a2a8-4c05-bd88-949f56d1bb01
begin

# Decomposition Filter 
	RXII=zeros(2^L1,2^L1,L1);
	GXII=zeros(2^L1,2^L1,L1);
	BXII=zeros(2^L1,2^L1,L1);
	for l=1:L1
		RXII[:,:,l]=dwt(RII, wavelet(WT.haar), l);
		GXII[:,:,l]=dwt(GII, wavelet(WT.haar), l);
		BXII[:,:,l]=dwt(BII, wavelet(WT.haar), l);
	end

# Splitting 
	RXIIapprox=zeros(2^L1,2^L1,L1);
	GXIIapprox=zeros(2^L1,2^L1,L1);
	BXIIapprox=zeros(2^L1,2^L1,L1);
	for l=1:L1
	    RXIIapprox[1:2^(L1-l),1:2^(L1-l),l]=RXII[1:2^(L1-l),1:2^(L1-l),l];
		GXIIapprox[1:2^(L1-l),1:2^(L1-l),l]=GXII[1:2^(L1-l),1:2^(L1-l),l];
		BXIIapprox[1:2^(L1-l),1:2^(L1-l),l]=BXII[1:2^(L1-l),1:2^(L1-l),l];
	end
	RXIIdetail=RXII-RXIIapprox;
	GXIIdetail=GXII-GXIIapprox;
	BXIIdetail=BXII-BXIIapprox;

# Composition Filter
	RYIIapprox=zeros(2^L1,2^L1,L1);
	RYIIdetail=zeros(2^L1,2^L1,L1);
	GYIIapprox=zeros(2^L1,2^L1,L1);
	GYIIdetail=zeros(2^L1,2^L1,L1);
	BYIIapprox=zeros(2^L1,2^L1,L1);
	BYIIdetail=zeros(2^L1,2^L1,L1);
	for l=1:L1
		RYIIapprox[:,:,l]=idwt(RXIIapprox[:,:,l], wavelet(WT.haar), l);
		RYIIdetail[:,:,l]=idwt(RXIIdetail[:,:,l], wavelet(WT.haar), l);
		GYIIapprox[:,:,l]=idwt(GXIIapprox[:,:,l], wavelet(WT.haar), l);
		GYIIdetail[:,:,l]=idwt(GXIIdetail[:,:,l], wavelet(WT.haar), l);
		BYIIapprox[:,:,l]=idwt(BXIIapprox[:,:,l], wavelet(WT.haar), l);
		BYIIdetail[:,:,l]=idwt(BXIIdetail[:,:,l], wavelet(WT.haar), l);
	end

# RGB
	ZIIapprox=zeros(3,2^L1,2^L1,L1+1);
	ZIIdetail=zeros(3,2^L1,2^L1,L1+1);
	ZIIapprox[1,:,:,1]=RII;
	ZIIapprox[2,:,:,1]=GII;
	ZIIapprox[3,:,:,1]=BII;
	for l=2:L1+1
		ZIIapprox[1,:,:,l]=RYIIapprox[:,:,l-1];
		ZIIapprox[2,:,:,l]=GYIIapprox[:,:,l-1];
		ZIIapprox[3,:,:,l]=BYIIapprox[:,:,l-1];
		ZIIdetail[1,:,:,l]=RYIIdetail[:,:,l-1];
		ZIIdetail[2,:,:,l]=GYIIdetail[:,:,l-1];
		ZIIdetail[3,:,:,l]=BYIIdetail[:,:,l-1];
	end

end

# ╔═╡ 1613c108-844e-4963-800a-2e9a137e3629
md""" 
##### 5-7. $8\times8$ RGB画像
レベル = $(@bind l1 Slider(0:L1, show_value=true))
"""

# ╔═╡ a8983c38-0bdd-4bbd-a592-0f42475d09af
begin
Q0=plot(colorview(RGB,ZIIapprox[:,:,:,1]),
        title="Original Image",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false);
Q1=plot(colorview(RGB,ZIIapprox[:,:,:,l1+1]),
        title="Approximation",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false);
Q2=plot(colorview(RGB,ZIIdetail[:,:,:,l1+1]),
        title="Detail",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
plot(Q0,Q1,Q2,layout=(1,3),size=(800,300))
end

# ╔═╡ e92557a9-f6d9-4495-ae81-9ad6318b63ec
begin

# Decomposition Filter 
	XR=zeros(p,q,L);
	XG=zeros(p,q,L);
	XB=zeros(p,q,L);
	for l=1:L
		XR[:,:,l]=dwt(R, wavelet(WT.haar), l);
		XG[:,:,l]=dwt(G, wavelet(WT.haar), l);
		XB[:,:,l]=dwt(B, wavelet(WT.haar), l);
	end

# Splitting 
	XRapprox=zeros(p,q,L);
	XGapprox=zeros(p,q,L);
	XBapprox=zeros(p,q,L);	
	for l=1:L
	XRapprox[1:Int(p/2^l),1:Int(q/2^l),l]=XR[1:Int(p/2^l),1:Int(q/2^l),l];
    XGapprox[1:Int(p/2^l),1:Int(q/2^l),l]=XG[1:Int(p/2^l),1:Int(q/2^l),l];
	XBapprox[1:Int(p/2^l),1:Int(q/2^l),l]=XB[1:Int(p/2^l),1:Int(q/2^l),l];
	end
	XRdetail=XR-XRapprox;
	XGdetail=XG-XGapprox;
	XBdetail=XB-XBapprox;

# Composition Filter
	YRapprox=zeros(p,q,L);
	YGapprox=zeros(p,q,L);
	YBapprox=zeros(p,q,L);
	YRdetail=zeros(p,q,L);
	YGdetail=zeros(p,q,L);
	YBdetail=zeros(p,q,L);
	for l=1:L
		YRapprox[:,:,l]=idwt(XRapprox[:,:,l], wavelet(WT.haar), l);
		YGapprox[:,:,l]=idwt(XGapprox[:,:,l], wavelet(WT.haar), l);
		YBapprox[:,:,l]=idwt(XBapprox[:,:,l], wavelet(WT.haar), l);
		YRdetail[:,:,l]=idwt(XRdetail[:,:,l], wavelet(WT.haar), l);
		YGdetail[:,:,l]=idwt(XGdetail[:,:,l], wavelet(WT.haar), l);
		YBdetail[:,:,l]=idwt(XBdetail[:,:,l], wavelet(WT.haar), l);
	end

# RGB
	Wapprox=zeros(3,p,q,L+1);
	Wdetail=zeros(3,p,q,L+1);
	Wapprox[:,:,:,1]=A;
	for l=2:L+1
		Wapprox[1,:,:,l]=YRapprox[:,:,l-1];
		Wapprox[2,:,:,l]=YGapprox[:,:,l-1];
		Wapprox[3,:,:,l]=YBapprox[:,:,l-1];
		Wdetail[1,:,:,l]=YRdetail[:,:,l-1];
		Wdetail[2,:,:,l]=YGdetail[:,:,l-1];
		Wdetail[3,:,:,l]=YBdetail[:,:,l-1];
	end
end

# ╔═╡ 2816c66d-9752-4b68-9234-58b896cd6805
md""" 
##### 5-8. $384\times512$ RGB画像
香港城市大学食堂の朝の経済飯　$384=2^7\times3$, $512=2^9$

レベル = $(@bind l Slider(0:L, show_value=true))
"""

# ╔═╡ 4fe40474-9f75-44db-a648-0e53dfb025d7
begin
P1=plot(colorview(RGB,A[:,:,:]),
        title="Origunal RGB Image",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
P2=plot(colorview(RGB,Wapprox[:,:,:,l+1]),
        title="Approximation",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
P3=plot(colorview(RGB,Wdetail[:,:,:,l+1]),
        title="Detail",
        xaxis=false, 
        xticks=false, 
        yaxis=false, 
        yticks=false, 
        grid=false);
plot(P1,P2,P3,size=(800,200),layout=(1,3))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DSP = "717857b8-e6f2-59f4-9121-6e50c889abd2"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
Formatting = "59287772-0a20-5a39-b81b-1366585eb4c0"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
ImageFiltering = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
ImageMagick = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
ImageTransformations = "02fcd773-0e25-5acc-982a-7f6622650795"
ImageView = "86fae568-95e7-573e-a6b2-d8a6b900c9ef"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
ImplicitPlots = "55ecb840-b828-11e9-1645-43f4a9f9ace7"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
LowRankApprox = "898213cb-b102-5a47-900c-97e73b919f73"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"
Wavelets = "29a6e085-ba6d-5f35-a997-948ac2efa89a"

[compat]
CSV = "~0.10.16"
Colors = "~0.13.1"
DSP = "~0.8.4"
DataFrames = "~1.7.1"
Formatting = "~0.4.3"
ForwardDiff = "~0.10.39"
ImageFiltering = "~0.7.12"
ImageMagick = "~1.4.2"
ImageTransformations = "~0.10.2"
ImageView = "~0.12.6"
Images = "~0.26.2"
ImplicitPlots = "~0.2.3"
LaTeXStrings = "~1.4.0"
LowRankApprox = "~0.5.5"
Plots = "~1.40.20"
PlutoUI = "~0.7.80"
Primes = "~0.5.7"
StatsBase = "~0.34.10"
Symbolics = "~6.38.0"
TestImages = "~1.9.0"
Wavelets = "~0.10.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.6"
manifest_format = "2.0"
project_hash = "57811ea0695c8741c25a68012ebfc71f293071c1"

[[deps.ADTypes]]
git-tree-sha1 = "f7304359109c768cf32dc5fa2d371565bb63b68a"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "1.21.0"

    [deps.ADTypes.extensions]
    ADTypesChainRulesCoreExt = "ChainRulesCore"
    ADTypesConstructionBaseExt = "ConstructionBase"
    ADTypesEnzymeCoreExt = "EnzymeCore"

    [deps.ADTypes.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "MacroTools"]
git-tree-sha1 = "2eeb2c9bef11013efc6f8f97f32ee59b146b09fb"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.44"

    [deps.Accessors.extensions]
    AxisKeysExt = "AxisKeys"
    IntervalSetsExt = "IntervalSets"
    LinearAlgebraExt = "LinearAlgebra"
    StaticArraysExt = "StaticArrays"
    StructArraysExt = "StructArrays"
    TestExt = "Test"
    UnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "0761717147821d696c9470a7a86364b2fbd22fd8"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.5.2"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "78b3a7a536b4b0a747a0f296ea77091ca0a9f9a3"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.23.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceAMDGPUExt = "AMDGPU"
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = ["CUDSS", "CUDA"]
    ArrayInterfaceChainRulesCoreExt = "ChainRulesCore"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceMetalExt = "Metal"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "4126b08903b777c88edf1754288144a0492c05ad"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.8"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Bessels]]
git-tree-sha1 = "4435559dc39793d53a9e3d278e185e920b4619ef"
uuid = "0e736298-9ec6-45e8-9647-e4fc86a2fe38"
version = "0.2.8"

[[deps.Bijections]]
git-tree-sha1 = "6aaafea90a56dc1fc8cbc15e3cf26d6bc81eb0a3"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.10"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Preferences", "Static"]
git-tree-sha1 = "f3a21d7fc84ba618a779d1ed2fcca2e682865bab"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.7"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "8d8e0b0f350b8e1c91420b5e64e5de774c2f0f4d"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.16"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "71aa551c5c33f1a4415867fe06b7844faadb0ae9"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.1.1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d0efe2c6fdcdaa1c161d206aa8b933788397ec71"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.6+0"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "12177ad6b3cad7fd50c8b3825ce24a99ad61c18f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.26.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ChunkCodecCore]]
git-tree-sha1 = "1a3ad7e16a321667698a19e77362b35a1e94c544"
uuid = "0b6fb165-00bc-4d37-ab8b-79f91016dbe1"
version = "1.0.1"

[[deps.ChunkCodecLibZlib]]
deps = ["ChunkCodecCore", "Zlib_jll"]
git-tree-sha1 = "cee8104904c53d39eb94fd06cbe60cb5acde7177"
uuid = "4c0bbee4-addc-4d73-81a0-b6caacae83c8"
version = "1.0.0"

[[deps.ChunkCodecLibZstd]]
deps = ["ChunkCodecCore", "Zstd_jll"]
git-tree-sha1 = "34d9873079e4cb3d0c62926a225136824677073f"
uuid = "55437552-ac27-4d47-9aa3-63184e8fd398"
version = "1.0.0"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "3e22db924e2945282e70c33b75d4dde8bfa44c94"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.8"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.CodecZstd]]
deps = ["TranscodingStreams", "Zstd_jll"]
git-tree-sha1 = "da54a6cd93c54950c15adf1d336cfd7d71f51a56"
uuid = "6b39b394-51ab-5f42-8807-6242bab2b4c2"
version = "0.8.7"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b0fd3f56fa442f81e0a47815c92245acfaaa4e34"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.31.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"
weakdeps = ["StyledStrings"]

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "8b3b6f87ce8f65a2b4f857528fd8d70086cd72b1"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.11.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "78ea4ddbcf9c241827e7035c3a03e2e456711470"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.6"

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.CompositeTypes]]
git-tree-sha1 = "bce26c3dab336582805503bed209faab1c279768"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.4"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "21d088c496ea22914fe80906eb5bce65755e5ec8"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.1"

[[deps.ConstructionBase]]
git-tree-sha1 = "b4b092499347b18a015186eae3042f72267106cb"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.6.0"
weakdeps = ["IntervalSets", "LinearAlgebra", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "a692f5e257d332de1e554e4566a4e5a8a72de2b2"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.4"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DSP]]
deps = ["Bessels", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "5989debfc3b38f736e69724818210c67ffee4352"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.8.4"
weakdeps = ["OffsetArrays"]

    [deps.DSP.extensions]
    OffsetArraysExt = "OffsetArrays"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "a37ac0840a1196cd00317b57e39d6586bf0fd6f6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.7.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "c7e3a542b999843086e2f29dac96a618c105be1d"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.12"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "fbcc7610f6d8348428f722ecbe0e6cfe22e672c6"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.123"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.DomainSets]]
deps = ["CompositeTypes", "FunctionMaps", "IntervalSets", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4599e0cd684f3ff6cbbab73c77553a3d01a8d74d"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.7.18"

    [deps.DomainSets.extensions]
    DomainSetsMakieExt = "Makie"
    DomainSetsRandomExt = "Random"

    [deps.DomainSets.weakdeps]
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.DynamicPolynomials]]
deps = ["Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Reexport", "Test"]
git-tree-sha1 = "ca693f8707a77a0e365d49fe4622203b72b6cf1d"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.6.3"

[[deps.EnumX]]
git-tree-sha1 = "c49898e8438c828577f04b92fc9368c388ac783c"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.7"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "27af30de8b5445644e8ffe3bcb0d72049c089cf1"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.7.3+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.ExproniconLite]]
git-tree-sha1 = "c13f0b150373771b0fdc1713c97860f8df12e6c2"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.14"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "95ecf07c2eea562b5adbd0696af6db62c0f52560"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.5"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libva_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "66381d7059b5f3f6162f28831854008040a4e905"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "8.0.1+1"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "Libdl", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "97f08406df914023af55ade2f843c39e99c5d969"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.10.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6d6219a004b8cf1e0b4dbe27a2860b8e04eba0be"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.11+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "6522cfb3b8fe97bec632252263057996cbd3de20"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.18.0"
weakdeps = ["HTTP"]

    [deps.FileIO.extensions]
    HTTPExt = "HTTP"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "3bab2c5aa25e7840a4b065805c0cdfc01f3068d2"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.24"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2f979084d1e13948a3352cf64a25df6bd3b4dca3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.16.0"
weakdeps = ["PDMats", "SparseArrays", "StaticArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStaticArraysExt = "StaticArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "f85dac9a96a01087df6e3a749840015a0ca3817d"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.17.1+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Formatting]]
deps = ["Logging", "Printf"]
git-tree-sha1 = "fb409abab2caf118986fc597ba84b50cbaf00b87"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.3"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "afb7c51ac63e40708a3071f80f5e84a752299d4f"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.39"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "70329abc09b886fd2c5d94ad2d9527639c421e3e"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.14.3+1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.FunctionMaps]]
deps = ["CompositeTypes", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "31bd99a57edf98990d1c21486032963955450e8d"
uuid = "a85aefff-f8ca-4649-a888-c8e5398bc76c"
version = "0.1.2"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers", "PrecompileTools", "TruncatedStacktraces"]
git-tree-sha1 = "3e13d0b39d117a03d3fb5c88a039e94787a37fcb"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "1.4.0"

    [deps.FunctionWrappersWrappers.extensions]
    FunctionWrappersWrappersEnzymeExt = ["Enzyme", "EnzymeCore"]
    FunctionWrappersWrappersMooncakeExt = "Mooncake"

    [deps.FunctionWrappersWrappers.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "b7bfd56fa66616138dfe5237da4dc13bbd83c67f"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.1+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "83cf05ab16a73219e5f6bd1bdfa9848fa24ac627"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.2.0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "44716a1a667cb867ee0e9ec8edc31c3e4aa5afdc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.24"

    [deps.GR.extensions]
    IJuliaExt = "IJulia"

    [deps.GR.weakdeps]
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "be8a1b8065959e24fdc1b51402f39f3b6f0f6653"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.24+0"

[[deps.GTK4_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "GettextRuntime_jll", "Glib_jll", "Graphene_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Libepoxy_jll", "Libtiff_jll", "PCRE2_jll", "Pango_jll", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libX11_jll", "Xorg_libXcursor_jll", "Xorg_libXdamage_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "Xorg_libXrender_jll", "gdk_pixbuf_jll", "iso_codes_jll", "xkbcommon_jll"]
git-tree-sha1 = "41c6d2ab0a034c35c6ba2c7d509d3a03da64fc69"
uuid = "6ebb71f1-8434-552f-b6b1-dc18babcca63"
version = "4.18.6+0"

[[deps.GettextRuntime_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll"]
git-tree-sha1 = "45288942190db7c5f760f59c04495064eedf9340"
uuid = "b0724c58-0f36-5564-988d-3bb0596ebc4a"
version = "0.22.4+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Zlib_jll"]
git-tree-sha1 = "38044a04637976140074d0b0621c1edf0eb531fd"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.1+0"

[[deps.Giflib_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6570366d757b50fabae9f4315ad74d2e40c0560a"
uuid = "59f7168a-df46-5410-90c8-f2779963d0ec"
version = "5.2.3+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "GettextRuntime_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "24f6def62397474a297bfcec22384101609142ed"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.86.3+0"

[[deps.Graphene_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "47a6897c1ce13a484b5f62643ed8f84e02babb05"
uuid = "75302f13-0b7e-5bab-a6d1-23fa92e4c2ea"
version = "1.10.8+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "a641238db938fff9b2f60d08ed9030387daf428c"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.3"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "7a98c6502f4632dbe9fb1973a4244eaa3324e84d"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.13.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Gtk4]]
deps = ["BitFlags", "CEnum", "Cairo", "Cairo_jll", "ColorTypes", "Dates", "FixedPointNumbers", "GTK4_jll", "Glib_jll", "Graphene_jll", "Graphics", "JLLWrappers", "Libdl", "Librsvg_jll", "Pango_jll", "Preferences", "Reexport", "Scratch", "Xorg_xkeyboard_config_jll", "adwaita_icon_theme_jll", "gdk_pixbuf_jll", "hicolor_icon_theme_jll", "libpng_jll"]
git-tree-sha1 = "10578b975a68cbe862390e7219b1f6da4b468766"
uuid = "9db2cae5-386f-4011-9d63-a5602296539b"
version = "0.7.12"

[[deps.GtkObservables]]
deps = ["Cairo", "Colors", "Dates", "FixedPointNumbers", "Graphics", "Gtk4", "IntervalSets", "LinearAlgebra", "Observables", "PrecompileTools", "Reexport", "RoundingIntegers"]
git-tree-sha1 = "7cd1331aece756ab5b76c9e401996faad42ea654"
uuid = "8710efd8-4ad6-11eb-33ea-2d5ceb25a41c"
version = "2.2.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "51059d23c8bb67911a2e6fd5130229113735fc7e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.11.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.HashArrayMappedTries]]
git-tree-sha1 = "2eaa69a7cab70a52b9687c8bf950a5a93ec895ae"
uuid = "076d061b-32b6-4027-95e0-9a2c6f6d7e74"
version = "0.2.0"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Preferences", "Static"]
git-tree-sha1 = "af9ab7d1f70739a47f03be78771ebda38c3c71bf"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.18"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "68c173f4f449de5b438ee67ed0c9c748dc31a2ec"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.28"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "e12629406c6c4442539436581041d372d69c55ba"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.12"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "33485b4e40d1df46c806498c73ea32dc17475c59"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.1"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "8c193230235bbcee22c8066b0374f63b5683c2d3"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.5"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "52116260a234af5f69969c5286e6a5f8dc3feab8"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.12"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs", "WebP"]
git-tree-sha1 = "696144904b76e1ca433b886b4e7edd067d76cbf7"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.9"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "8e64ab2f0da7b928c8ae889c514a52741debc1c2"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.4.2"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Bzip2_jll", "FFTW_jll", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "OpenJpeg_jll", "Zlib_jll", "Zstd_jll", "libpng_jll", "libwebp_jll", "libzip_jll"]
git-tree-sha1 = "2c232857f2eb9ecfa3ab534df7f060c9afbeb187"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "7.1.2011+0"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "2a81c3897be6fbcde0802a0ebe6796d0562f63ec"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.10"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "cffa21df12f00ca1a365eb8ed107614b40e8c6da"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.6"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "7196039573b6f312864547eb7a74360d6c0ab8e6"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.9.0"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "dfde81fafbe5d6516fb864dc79362c5c6b973c82"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.2"

[[deps.ImageView]]
deps = ["AxisArrays", "Cairo", "Compat", "Graphics", "Gtk4", "GtkObservables", "ImageBase", "ImageCore", "ImageMetadata", "MultiChannelColors", "PrecompileTools", "RoundingIntegers", "StatsBase"]
git-tree-sha1 = "e535c709a4fb6f0ae65026fa9bfac624abec016f"
uuid = "86fae568-95e7-573e-a6b2-d8a6b900c9ef"
version = "0.12.6"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "a49b96fd4a8d1a9a718dfd9cde34c154fc84fcd5"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.2"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dcc8d0cd653e55213df9b75ebc6fe4a8d3254c65"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.2.2+0"

[[deps.ImplicitPlots]]
deps = ["Contour", "MultivariatePolynomials", "RecipesBase", "Requires", "StaticArrays", "StaticPolynomials"]
git-tree-sha1 = "baaa32fec0346ccf55b61972858f33809d8f9694"
uuid = "55ecb840-b828-11e9-1645-43f4a9f9ace7"
version = "0.2.3"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.InlineStrings]]
git-tree-sha1 = "8f3d257792a522b4601c24a577954b0a8cd7334d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.5"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "4c1acff2dc6b6967e7e750633c50bc3b8d83e617"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.3"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "b842cbff3f44804a84fda409745cc8f04c029a20"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.6"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "ec1debd61c300961f98064cfb21287613ad7f303"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2025.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "65d505fa4c0d7072990d659ef3fc086eb6da8208"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.16.2"
weakdeps = ["ForwardDiff", "Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsForwardDiffExt = "ForwardDiff"
    InterpolationsUnitfulExt = "Unitful"

[[deps.IntervalSets]]
git-tree-sha1 = "79d6bd28c8d9bccc2229784f1bd637689b256377"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.14"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InverseFunctions]]
git-tree-sha1 = "a779299d77cd080bf77b97535acecd73e1c5e5cb"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.17"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.InvertedIndices]]
git-tree-sha1 = "6da3c4316095de0f5ee2ebd875df8721e7e0bdbe"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.1"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["ChunkCodecLibZlib", "ChunkCodecLibZstd", "FileIO", "MacroTools", "Mmap", "OrderedCollections", "PrecompileTools", "ScopedValues"]
git-tree-sha1 = "941f87a0ae1b14d1ac2fa57245425b23a9d7a516"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.6.4"
weakdeps = ["UnPack"]

    [deps.JLD2.extensions]
    UnPackExt = "UnPack"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Logging", "Parsers", "PrecompileTools", "StructUtils", "UUIDs", "Unicode"]
git-tree-sha1 = "67c6f1f085cb2671c93fe34244c9cccde30f7a26"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "1.5.0"

    [deps.JSON.extensions]
    JSONArrowExt = ["ArrowTypes"]

    [deps.JSON.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.Jieko]]
deps = ["ExproniconLite"]
git-tree-sha1 = "2f05ed29618da60c06a87e9c033982d4f71d0b6c"
uuid = "ae98c720-c025-4a4a-838c-29b094483192"
version = "0.2.1"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "9496de8fb52c224a2e3f9ff403947674517317d9"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.6"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c0c9b76f3520863909825cbecdef58cd63de705a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.5+0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "059aabebaa7c82ccb853dd4a0ee9d17796f7e1bc"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.3+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "17b94ecafcfa45e8360a4fc9ca6b583b049e4e37"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.1.0+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "Ghostscript_jll", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "44f93c47f9cd6c7e431f2f2091fcba8f01cd7e8f"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.10"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.15.0+0"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libepoxy_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libX11_jll"]
git-tree-sha1 = "94d068f57b4241dd090693b6aba63416892298de"
uuid = "42c93a91-0102-5b3f-8f9d-e41de60ac950"
version = "1.5.11+0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c8da7e6a91781c41a863611c7e966098d783c57a"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.4.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "97bbca976196f2a1eb9607131cb108c69ec3f8a6"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.3+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "Cairo_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "Libdl", "Pango_jll", "XML2_jll", "gdk_pixbuf_jll"]
git-tree-sha1 = "e6ab5dda9916d7041356371c53cdc00b39841c31"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.7+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "f04133fe05eff1667d2054c53d59f9122383fe05"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.2+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d0205286d9eceadc518742860bf23f703779a3d6"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.3+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.LittleCMS_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll"]
git-tree-sha1 = "8e6a74641caf3b84800f2ccd55dc7ab83893c10b"
uuid = "d3a379c0-f9a3-5b72-a4c0-6bf4d2e8af0f"
version = "2.17.0+0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f00544d95982ea270145636c181ceda21c4e2575"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.2.0"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "a9fc7883eb9b5f04f46efb9a540833d1fad974b3"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.173"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    ForwardDiffNNlibExt = ["ForwardDiff", "NNlib"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    NNlib = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.LowRankApprox]]
deps = ["FFTW", "LinearAlgebra", "LowRankMatrices", "Nullables", "Random", "SparseArrays"]
git-tree-sha1 = "031af63ba945e23424815014ba0e59c28f5aed32"
uuid = "898213cb-b102-5a47-900c-97e73b919f73"
version = "0.5.5"

[[deps.LowRankMatrices]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "59c5bb0708be6796604caec16d4357013dc3d132"
uuid = "e65ccdef-c354-471a-8090-89bec1c20ec3"
version = "1.0.2"
weakdeps = ["FillArrays"]

    [deps.LowRankMatrices.extensions]
    LowRankMatricesFillArraysExt = "FillArrays"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "282cadc186e7b2ae0eeadbd7a4dffed4196ae2aa"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2025.2.0+0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "0ee4497a4e80dbd29c058fcee6493f5219556f40"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.3"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "8785729fa736197687541f7053f6d8ab7fc44f92"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.10"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ff69a2b1330bcb730b9ac1ab7dd680176f5896b8"
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.1010+0"

[[deps.Measures]]
git-tree-sha1 = "b513cedd20d9c914783d8ad83d08120702bf2c77"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.3"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "3a8f462a180a9d735e340f4e8d5f364d411da3a4"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.8.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.Moshi]]
deps = ["ExproniconLite", "Jieko"]
git-tree-sha1 = "53f817d3e84537d84545e0ad749e483412dd6b2a"
uuid = "2e0e35c7-a2e4-4343-998d-7ef72827ed2d"
version = "0.3.7"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.11.4"

[[deps.MultiChannelColors]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "Compat", "FixedPointNumbers", "LinearAlgebra", "Reexport", "Requires"]
git-tree-sha1 = "c4dce3e565ee81dccd3b588a7ea08cfc67778339"
uuid = "d4071afc-4203-49ee-90bc-13ebeb18d604"
version = "0.1.4"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "fade91fe9bee7b142d332fc6ab3f0deea29f637b"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.5.9"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7c25249fc13a070f5ba433c50e21e22bb33c6fb0"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.7.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NearestNeighbors]]
deps = ["AbstractTrees", "Distances", "StaticArrays"]
git-tree-sha1 = "e2c3bba08dd6dedfe17a17889131b885b8c082f0"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.27"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.Nullables]]
git-tree-sha1 = "8f87854cc8f3685a60689d8edecaa29d2251979b"
uuid = "4d1e1d77-625e-5b40-9113-a560ec7a8ecd"
version = "1.0.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6aa4566bb7ae78498a5e68943863fa8b5231b59"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.6+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "97db9e07fe2091882c765380ef58ec553074e9c7"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.3"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "135492b7e97fc86d9b132b96a54d2d3dd3e0c6a8"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.4.8+0"

[[deps.OpenJpeg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libtiff_jll", "LittleCMS_jll", "libpng_jll"]
git-tree-sha1 = "215a6666fee6d6b3a6e75f2cc22cb767e2dd393a"
uuid = "643b3616-a352-519d-856d-80112ee9badc"
version = "2.5.5+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.7+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "NetworkOptions", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "1d1aaa7d449b58415f97d2839c318b70ffb525a0"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.6.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e2bb57a313a74b8104064b7efd01406c0a50d2ff"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.6.1+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.44.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e4cff168707d441cd6bf3ff7e4832bdf34278e4a"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.37"
weakdeps = ["StatsBase"]

    [deps.PDMats.extensions]
    StatsBaseExt = "StatsBase"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "cf181f0b1e6a18dfeb0ee8acc4a9d1672499626c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.4"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0662b083e11420952f2e62e17eddae7fc07d5997"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.57.0+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.1"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "26ca162858917496748aad52bb5d3be4d26a228a"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "bfe839e9668f0c58367fb62d8757315c0eac8777"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.20"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "fbc875044d82c113a9dee6fc14e16cf01fd48872"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.80"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "OrderedCollections", "Setfield", "SparseArrays"]
git-tree-sha1 = "2d99b4c8a7845ab1342921733fa29366dae28b24"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "4.1.1"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsFFTWExt = "FFTW"
    PolynomialsMakieExt = "Makie"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"
    PolynomialsRecipesBaseExt = "RecipesBase"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "PrecompileTools"]
git-tree-sha1 = "c05b4c6325262152483a1ecb6c69846d2e01727b"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.34"

    [deps.PreallocationTools.extensions]
    PreallocationToolsForwardDiffExt = "ForwardDiff"
    PreallocationToolsReverseDiffExt = "ReverseDiff"
    PreallocationToolsSparseConnectivityTracerExt = "SparseConnectivityTracer"

    [deps.PreallocationTools.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseConnectivityTracer = "9f842d2f-2579-4b1d-911e-f412cf18a3f5"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "1101cd475833706e4d0e7b122218257178f48f34"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.4.0"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "25cdd1d20cd005b52fc12cb6be3f75faaf59bb9b"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "fbb92c6c56b34e1a2c4c36058f68f332bec840e7"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "472daaa816895cb7aee81658d4e7aec901fa1106"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.2"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "d7a4bff94f42208ce3cf6bc8e4e7d1d663e7ee8b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.10.2+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll", "Qt6Svg_jll"]
git-tree-sha1 = "d5b7dd0e226774cbd87e2790e34def09245c7eab"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.10.2+1"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "4d85eedf69d875982c46643f6b4f66919d7e157b"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.10.2+1"

[[deps.Qt6Svg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "81587ff5ff25a4e1115ce191e36285ede0334c9d"
uuid = "6de9746b-f93d-5813-b365-ba18ad4a9cf3"
version = "6.10.2+0"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "672c938b4b4e3e0169a07a5f227029d4905456f2"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.10.2+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "5e8e8b0ab68215d7a2b14b9921a946fee794749e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.3"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "4d8c1b7c3329c1885b857abb50d08fa3f4d9e3c8"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.7"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "LinearAlgebra", "PrecompileTools", "RecipesBase", "StaticArraysCore", "SymbolicIndexingInterface"]
git-tree-sha1 = "d0282d612f22dcad7b81cf487b746e63aa2a6709"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.54.0"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsFastBroadcastPolyesterExt = ["FastBroadcast", "Polyester"]
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsKernelAbstractionsExt = "KernelAbstractions"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsSparseArraysExt = ["SparseArrays"]
    RecursiveArrayToolsStatisticsExt = "Statistics"
    RecursiveArrayToolsStructArraysExt = "StructArrays"
    RecursiveArrayToolsTablesExt = ["Tables"]
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "5b3d50eb374cea306873b371d3f8d3915a018f0b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.9.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "5680a9276685d392c87407df00d57c9924d9f11e"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.7.1"
weakdeps = ["RecipesBase"]

    [deps.Rotations.extensions]
    RotationsRecipesBaseExt = "RecipesBase"

[[deps.RoundingIntegers]]
git-tree-sha1 = "99acd97f396ea71a5be06ba6de5c9defe188a778"
uuid = "d5f540fe-1c90-5db3-b776-2e2f362d9394"
version = "1.1.0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cfcdc949c4660544ab0fdeed169561cb22f835f4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.18"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "e24dc23107d426a096d3eae6c165b921e74c18e4"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.7.2"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "456f610ca2fbd1c14f5fcf31c6bfadc55e7d66e0"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.43"

[[deps.SciMLBase]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "Moshi", "PreallocationTools", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLLogging", "SciMLOperators", "SciMLPublic", "SciMLStructures", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface"]
git-tree-sha1 = "908c0bf271604d09393a21c142116ab26f66f67c"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.154.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseDifferentiationInterfaceExt = "DifferentiationInterface"
    SciMLBaseDistributionsExt = "Distributions"
    SciMLBaseEnzymeExt = "Enzyme"
    SciMLBaseForwardDiffExt = "ForwardDiff"
    SciMLBaseMLStyleExt = "MLStyle"
    SciMLBaseMakieExt = "Makie"
    SciMLBaseMeasurementsExt = "Measurements"
    SciMLBaseMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    SciMLBaseMooncakeExt = "Mooncake"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseReverseDiffExt = "ReverseDiff"
    SciMLBaseTrackerExt = "Tracker"
    SciMLBaseZygoteExt = ["Zygote", "ChainRulesCore"]

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DifferentiationInterface = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    MLStyle = "d8e11817-5142-5d16-987a-aa16d5891078"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLLogging]]
deps = ["Logging", "LoggingExtras", "Preferences"]
git-tree-sha1 = "0161be062570af4042cf6f69e3d5d0b0555b6927"
uuid = "a6db7da4-7206-11f0-1eab-35f2a5dbe1d1"
version = "1.9.1"

    [deps.SciMLLogging.extensions]
    SciMLLoggingTracyExt = "Tracy"

    [deps.SciMLLogging.weakdeps]
    Tracy = "e689c965-62c8-4b79-b2c5-8359227902fd"

[[deps.SciMLOperators]]
deps = ["Accessors", "ArrayInterface", "DocStringExtensions", "LinearAlgebra"]
git-tree-sha1 = "234869cf9fee9258a95464b7a7065cc7be84db00"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "1.16.0"
weakdeps = ["SparseArrays", "StaticArraysCore"]

    [deps.SciMLOperators.extensions]
    SciMLOperatorsSparseArraysExt = "SparseArrays"
    SciMLOperatorsStaticArraysCoreExt = "StaticArraysCore"

[[deps.SciMLPublic]]
git-tree-sha1 = "0ba076dbdce87ba230fff48ca9bca62e1f345c9b"
uuid = "431bcebd-1456-4ced-9d72-93c2757fff0b"
version = "1.0.1"

[[deps.SciMLStructures]]
deps = ["ArrayInterface", "PrecompileTools"]
git-tree-sha1 = "607f6867d0b0553e98fc7f725c9f9f13b4d01a32"
uuid = "53ae85a6-f571-4167-b2af-e1d143709226"
version = "1.10.0"

[[deps.ScopedValues]]
deps = ["HashArrayMappedTries", "Logging"]
git-tree-sha1 = "ac4b837d89a58c848e85e698e2a2514e9d59d8f6"
uuid = "7e506255-f358-4e82-b7e4-beb19740aa63"
version = "1.6.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ebe7e59b37c400f694f52b58c93d26201387da70"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.9"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "c5391c6ace3bc430ca630251d02ea9687169ca68"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "be8eeac05ec97d379347584fa9fe2f5f76795bcb"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.5"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "749a2b719ec7f34f280c0d97ac3dab5c89818631"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.5.1"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "0494aed9501e7fb65daba895fb7fd57cc38bc743"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.5"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2700b235561b0335d5bef7097a111dc513b8655e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.7.2"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "4f96c596b8c8258cc7d3b19797854d368f243ddc"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.4"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "be1cf4eb0ac528d96f5115b4ed80c26a8d8ae621"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.2"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools", "SciMLPublic"]
git-tree-sha1 = "49440414711eddc7227724ae6e570c7d5559a086"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.3.1"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "SciMLPublic", "Static"]
git-tree-sha1 = "aa1ea41b3d45ac449d10477f65e2b40e3197a0d2"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.9.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "246a8bb2e6667f832eea063c3a56aef96429a3db"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.18"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6ab403037779dae8c514bad259f32a447262455a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.4"

[[deps.StaticPolynomials]]
deps = ["LinearAlgebra", "MultivariatePolynomials", "StaticArrays"]
git-tree-sha1 = "0b4ec86a5ba2269c51897381dd0e7a222650f447"
uuid = "62e018b1-6e46-5407-a5a7-97d4fbcae734"
version = "1.3.7"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "aceda6f4e598d331548e04cc6b2124a6148138e3"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.10"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "91f091a8716a6bb38417a6e6f274602a19aaa685"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.5.2"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "5b2ca70b099f91e54d98064d5caf5cc9b541ad06"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.3"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "d05693d339e37d6ab134c5ab53c29fce5ee5d7d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.4"

[[deps.StructUtils]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "fa95b3b097bcef5845c142ea2e085f1b2591e92c"
uuid = "ec057cc2-7a8d-4b58-b3b3-92acb9f63b42"
version = "2.7.1"

    [deps.StructUtils.extensions]
    StructUtilsMeasurementsExt = ["Measurements"]
    StructUtilsStaticArraysCoreExt = ["StaticArraysCore"]
    StructUtilsTablesExt = ["Tables"]

    [deps.StructUtils.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

[[deps.SymbolicIndexingInterface]]
deps = ["Accessors", "ArrayInterface", "RuntimeGeneratedFunctions", "StaticArraysCore"]
git-tree-sha1 = "b19cf024a2b11d72bef7c74ac3d1cbe86ec9e4ed"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.44"
weakdeps = ["PrettyTables"]

    [deps.SymbolicIndexingInterface.extensions]
    SymbolicIndexingInterfacePrettyTablesExt = "PrettyTables"

[[deps.SymbolicLimits]]
deps = ["SymbolicUtils"]
git-tree-sha1 = "f75c7deb7e11eea72d2c1ea31b24070b713ba061"
uuid = "19f23fe9-fdab-4a78-91af-e7b7767979c3"
version = "0.2.3"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "ArrayInterface", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "ExproniconLite", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "TaskLocalValues", "TermInterface", "TimerOutputs", "Unityper"]
git-tree-sha1 = "a85b4262a55dbd1af39bb6facf621d79ca6a322d"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "3.32.0"

    [deps.SymbolicUtils.extensions]
    SymbolicUtilsLabelledArraysExt = "LabelledArrays"
    SymbolicUtilsReverseDiffExt = "ReverseDiff"

    [deps.SymbolicUtils.weakdeps]
    LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.Symbolics]]
deps = ["ADTypes", "ArrayInterface", "Bijections", "CommonWorldInvalidations", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "DynamicPolynomials", "LaTeXStrings", "Latexify", "Libdl", "LinearAlgebra", "LogExpFunctions", "MacroTools", "Markdown", "NaNMath", "OffsetArrays", "PrecompileTools", "Primes", "RecipesBase", "Reexport", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArraysCore", "SymbolicIndexingInterface", "SymbolicLimits", "SymbolicUtils", "TermInterface"]
git-tree-sha1 = "e46dbf646bc3944c22a37745361c2e0a94f81d66"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "6.38.0"

    [deps.Symbolics.extensions]
    SymbolicsForwardDiffExt = "ForwardDiff"
    SymbolicsGroebnerExt = "Groebner"
    SymbolicsLuxExt = "Lux"
    SymbolicsNemoExt = "Nemo"
    SymbolicsPreallocationToolsExt = ["PreallocationTools", "ForwardDiff"]
    SymbolicsSymPyExt = "SymPy"

    [deps.Symbolics.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Groebner = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
    Lux = "b2108857-7c20-44ae-9111-449ecde12c47"
    Nemo = "2edaba10-b0f1-5616-af89-8c11ac63239a"
    PreallocationTools = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "f2c1efbc8f3a609aadf318094f8fc5204bdaf344"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TaskLocalValues]]
git-tree-sha1 = "67e469338d9ce74fc578f7db1736a74d93a49eb8"
uuid = "ed4db957-447d-4319-bfb6-7fa9ae7ecf34"
version = "0.1.3"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TermInterface]]
git-tree-sha1 = "d673e0aca9e46a2f63720201f55cc7b3e7169b16"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "2.0.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TestImages]]
deps = ["AxisArrays", "ColorTypes", "FileIO", "ImageIO", "ImageMagick", "OffsetArrays", "Pkg", "StringDistances"]
git-tree-sha1 = "fc32a2c7972e2829f34cf7ef10bbcb11c9b0a54c"
uuid = "5e47fb64-e119-507b-a336-dd2b206d9990"
version = "1.9.0"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "d969183d3d244b6c33796b5ed01ab97328f2db85"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.5"

[[deps.TiffImages]]
deps = ["CodecZstd", "ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "PrecompileTools", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "9ca5f1f2d42f80df4b8c9f6ab5a64f438bbd9976"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.11.9"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "3748bd928e68c7c346b52125cf41fff0de6937d0"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.29"

    [deps.TimerOutputs.extensions]
    FlameGraphsExt = "FlameGraphs"

    [deps.TimerOutputs.weakdeps]
    FlameGraphs = "08572546-2f56-4bcf-ba4e-bab62c3a3f89"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "6258d453843c466d84c17a58732dda5deeb8d3af"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.24.0"
weakdeps = ["ConstructionBase", "ForwardDiff", "InverseFunctions", "Printf"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    ForwardDiffExt = "ForwardDiff"
    InverseFunctionsUnitfulExt = "InverseFunctions"
    PrintfExt = "Printf"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "af305cc62419f9bd61b6644d19170a4d258c7967"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.7.0"

[[deps.Unityper]]
deps = ["ConstructionBase"]
git-tree-sha1 = "25008b734a03736c41e2a7dc314ecb95bd6bbdb0"
uuid = "a7c27f48-0311-42f6-a7f8-2c11e75eb415"
version = "0.1.6"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "d1d9a935a26c475ebffd54e9c7ad11627c43ea85"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.72"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wavelets]]
deps = ["DSP", "FFTW", "LinearAlgebra", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "d0ec97a100abbe47a5e9a02361841da49cce6029"
uuid = "29a6e085-ba6d-5f35-a997-948ac2efa89a"
version = "0.10.1"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "96478df35bbc2f3e1e791bc7a3d0eeee559e60e9"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.24.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "54b8a029ac145ebe8299463447fd1590b2b1d92f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.44.0+0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WebP]]
deps = ["CEnum", "ColorTypes", "FileIO", "FixedPointNumbers", "ImageCore", "libwebp_jll"]
git-tree-sha1 = "aa1ca3c47f119fbdae8770c29820e5e6119b83f2"
uuid = "e3aaa7dc-3e4b-44e0-be63-ffb868ccd7c1"
version = "0.1.3"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "248a7031b3da79a127f14e5dc5f417e26f9f6db7"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.1.0"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "80d3930c6347cfce7ccf96bd3bafdf079d9c0390"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.9+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b29c22e245d092b8b4e8d3c09ad7baa586d9f573"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.3+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "808090ede1d41644447dd5cbafced4731c56bd2f"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.13+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[deps.Xorg_libXdamage_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll"]
git-tree-sha1 = "45917154defafcbff585d6c04f323b5797da1ecf"
uuid = "0aeada51-83db-5f97-b67e-184615cfc6f6"
version = "1.1.7+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "1a4a26870bf1e5d26cd585e38038d399d7e65706"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.8+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "75e00946e43621e09d431d9b95818ee751e6b2ef"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.2+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "0ba01bc7396896a4ace8aab67db31403c71628f4"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.7+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c174ef70c96c76f4c3f4d3cfbe09d018bcd1b53"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.6+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libpciaccess_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "4909eb8f1cbf6bd4b1c30dd18b2ead9019ef2fad"
uuid = "a65dc6b1-eb27-53a1-bb3e-dea574b5389e"
version = "0.18.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "ed756a03e95fff88d8f738ebc2849431bdd4fd1a"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.2.0+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "9750dc53819eba4e9a20be42349a6d3b86c7cdf8"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.6+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f4fc02e384b74418679983a97385644b67e1263b"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll"]
git-tree-sha1 = "68da27247e7d8d8dafd1fcf0c3654ad6506f5f97"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "44ec54b0e2acd408b0fb361e1e9244c60c9c3dd4"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "5b0263b6d080716a02544c55fdff2c8d7f9a16a0"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.10+0"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f233c83cad1fa0e70b7771e0e21b061a116f2763"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.2+0"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.adwaita_icon_theme_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "hicolor_icon_theme_jll"]
git-tree-sha1 = "28401767f30e5743ef5e3b0be71417bc911d3952"
uuid = "b437f822-2cd6-5e08-a15c-8bac984d38ee"
version = "43.0.1+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c3b0e6196d50eab0c5ed34021aaa0bb463489510"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.14+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "895f21b699121d1a57ecac57e65a852caf569254"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.13+0"

[[deps.hicolor_icon_theme_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8f7bcbb45ea61c1ab3d5508413ff5d69565e3ff1"
uuid = "059c91fe-1bad-52ad-bddd-f7b78713c282"
version = "0.18.0+0"

[[deps.iso_codes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6d3b2c8a4870c50f41bbd58131ed9af581c675b5"
uuid = "bf975903-5238-5d20-8243-bc370bc1e7e5"
version = "4.20.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "371cc681c00a3ccc3fbc5c0fb91f58ba9bec1ecf"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.13.1+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "125eedcb0a4a0bba65b657251ce1d27c8714e9d6"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.17.4+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libdrm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libpciaccess_jll"]
git-tree-sha1 = "63aac0bcb0b582e11bad965cef4a689905456c03"
uuid = "8e53e030-5e6c-5a89-a30b-be5b7263a166"
version = "2.4.125+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "56d643b57b188d30cccc25e331d416d3d358e557"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.13.4+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "646634dd19587a56ee2f1199563ec056c5f228df"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.4+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "91d05d7f4a9f67205bd6cf395e488009fe85b499"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.28.1+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "45a20bd63e4fafc84ed9e4ac4ba15c8a7deff803"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.57+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "libpng_jll"]
git-tree-sha1 = "c1733e347283df07689d71d61e14be986e49e47a"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.5+0"

[[deps.libva_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "libdrm_jll"]
git-tree-sha1 = "7dbf96baae3310fe2fa0df0ccbb3c6288d5816c9"
uuid = "9a156e7d-b971-5f62-b2c9-67348b8fb97c"
version = "2.23.0+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll"]
git-tree-sha1 = "11e1772e7f3cc987e9d3de991dd4f6b2602663a5"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.8+0"

[[deps.libwebp_jll]]
deps = ["Artifacts", "Giflib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Libtiff_jll", "libpng_jll"]
git-tree-sha1 = "4e4282c4d846e11dce56d74fa8040130b7a95cb3"
uuid = "c5f90fcd-3b7e-5836-afba-fc50a0988cb2"
version = "1.6.0+0"

[[deps.libzip_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "OpenSSL_jll", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "86addc139bca85fdf9e7741e10977c45785727b7"
uuid = "337d8026-41b4-5cde-a456-74a10e5b31d1"
version = "1.11.3+0"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b4d631fd51f2e9cdd93724ae25b2efc198b059b1"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.7+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "1350188a69a6e46f799d3945beef36435ed7262f"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2022.0.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.7.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14cc7083fc6dff3cc44f2bc435ee96d06ed79aa7"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.1+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e7b67590c14d487e734dcb925924c5dc43ec85f3"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "4.1.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "a1fc6507a40bf504527d0d4067d718f8e179b2b8"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.13.0+0"
"""

# ╔═╡ Cell order:
# ╟─5ffc5ec0-f91f-11ec-0552-37ef5f25102d
# ╟─f3034480-e17d-4a7b-bdf3-cfb1d55d7bb9
# ╟─0a085483-72c0-4ec5-a677-9cf09f05cc54
# ╟─61a2ad36-a448-4de8-8665-b99fefcc2fb4
# ╟─c0e2ce61-cadd-482a-8b11-0bafb040d15a
# ╟─2aa2a4f4-65d4-43e4-b8fb-13bcca1b84b9
# ╟─f04f494d-99cb-4d99-9c25-04a841fe3bc5
# ╟─7d7e3384-cce9-4a97-bd78-604932418d56
# ╟─38a19ae1-07b9-414c-999c-c74d2b8df7d5
# ╟─21c924bb-23de-42ac-805b-a19744a8e105
# ╟─0cf2d2df-87dd-4201-8b74-087c94ff37de
# ╟─f68a62e7-f442-49d1-bd1d-b7268d55f037
# ╟─3315d5ae-444e-4958-a1d7-086eeaaad522
# ╟─6450807b-e3e9-43e6-bd64-50c385c077ce
# ╟─0f18af6e-c2ba-43df-8299-2c42821c8c17
# ╟─9f9c9544-7454-4277-84a4-7a2b46fdea2f
# ╟─179fda5c-5ef8-4990-9f37-05b2668a3583
# ╟─48b3fdb1-952e-49c4-9879-85dba253d467
# ╟─9ef7fc3e-e71d-4aa8-9216-e61caab1ede3
# ╟─ffaaa261-48fd-4e3d-a577-b0099d707b39
# ╟─813bd0ba-df4a-4765-8bc3-c3ac1724da20
# ╟─187608da-21d7-4e3a-ab7c-875c1de0ef2b
# ╟─bd804a6d-f4c2-45fa-ba0d-aa22fafdbf15
# ╟─6ec1cea1-13dc-47cc-9c79-1d4020365ad0
# ╟─3ea73ad7-9c0d-495a-b1cb-66ead132ab25
# ╟─cdbd7b78-b235-432f-9a11-ed61f5a00936
# ╟─0194933c-1a91-4489-ac98-95bb5ef8006c
# ╟─9b1a2ff8-691f-4feb-9f1a-f4d25f1db427
# ╟─4c03395c-c24b-4899-91a9-eb507ca313f6
# ╟─c0bb942b-0812-4478-8df4-d6b64724eafd
# ╟─d694c456-8b02-45f9-807b-ac3099cfeb09
# ╟─0f025462-d22d-4ca3-862e-d9dbdc471863
# ╟─0b31d278-fbae-4794-b1e1-d5f7fdd8852d
# ╟─96dbf33e-1645-41c8-b20c-aa3f8d77c89d
# ╟─b89b2541-4928-4086-830c-2a8d04d5da01
# ╟─748100f1-caaa-4cef-92ed-3e3604ded2d2
# ╟─38bc4005-c48e-4def-9e06-28164a5c02cb
# ╟─b7f5b953-07cb-4857-8ca2-7d79b9d91a93
# ╟─5a1f0965-3bce-4119-8857-9abc085ff411
# ╟─559c0598-6921-4778-8b47-f476c30e9961
# ╟─ad07fbe6-26b4-4adc-afb8-d78170a96e0e
# ╟─56fe3ad1-44d8-4b29-b4b5-e924c5e7e1d4
# ╟─bd8d3048-a833-4627-be53-7442b5adfb3c
# ╟─4d5570ee-cfef-4678-a95e-1e5fbddfa543
# ╟─dcfa857c-8c43-460d-be11-fbe339bc59ae
# ╟─2bad901b-e7a0-4762-81c7-55a6681002fd
# ╟─51d589cd-844f-4c4d-8f8b-b78c0bf64e22
# ╟─c2c168de-c414-40cb-8e71-897cbe91f6e1
# ╟─a0402d67-3da5-4c70-9506-1c1cdd6adb36
# ╟─19714ade-03b2-438e-859f-69c437a937f3
# ╟─542e397f-c6cb-4c4a-aa2f-0022923c2b38
# ╟─3b081afb-c168-4e6a-b766-837e35c3eea4
# ╟─5cddd44b-2363-419c-881a-d8c8d4b17510
# ╟─6bbad8f1-f9ce-40a9-8fdb-18129871266b
# ╟─e44795e3-a2a8-4c05-bd88-949f56d1bb01
# ╟─1613c108-844e-4963-800a-2e9a137e3629
# ╟─a8983c38-0bdd-4bbd-a592-0f42475d09af
# ╟─e92557a9-f6d9-4495-ae81-9ad6318b63ec
# ╟─2816c66d-9752-4b68-9234-58b896cd6805
# ╟─4fe40474-9f75-44db-a648-0e53dfb025d7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
