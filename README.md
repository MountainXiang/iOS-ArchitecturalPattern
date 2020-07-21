# iOS-ArchitecturalPattern
Demo for iOS architectural pattern of MVC,MVP and MVVM.

> [MVC](https://en.wikipedia.org/wiki/Model–view–controller)

![MVC_出自斯坦福大学CS193课程的课件](https://upload-images.jianshu.io/upload_images/10593309-36388ea2b7596d61.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
Model = What your application is (but not how it is displayed)
Controller = How your Model is presented to the user (UI logic)
View = Your Controller's minions

It's all about managing communication between camps:
Controllers can always talk directly to their Model.
Controllers can also talk directly to their View.
The Model and View should never speak to each other (Concerns Model and View's Reuse).

Sometimes the View needs to synchronize with the Controller.
The Controller sets itself as the View's delegate.

Views do not own the data they display.
Controllers are almost always that data source (not Model!).
```
![Traditional version of MVC as a compound pattern](https://upload-images.jianshu.io/upload_images/10593309-b06f288f887fd43e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![Cocoa version of MVC as a compound design pattern](https://upload-images.jianshu.io/upload_images/10593309-823d22e498916f71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Realistic Cocoa version of MVC](https://upload-images.jianshu.io/upload_images/10593309-608b153f39aa0e85.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Cocoa 的 MVC 模式驱使人们写出臃肿的视图控制器，因为它们经常被混杂到 View 的生命周期中，因此很难说 View 和 ViewController 是分离的。尽管仍可以将业务逻辑和数据转换到 Model，但是大多数情况下当需要为 View 减负的时候我们却无能为力了，View 的最大的任务就是向 Controller 传递用户动作事件。ViewController 不再承担一切代理和数据源的职责，通常只负责一些分发和取消网络请求以及一些其他的任务。

你可能会看见过很多次这样的代码:
```
BookModel *bookModel = [myDataArray objectAtIndex:indexPath.row];
[cell configWithModel:bookModel];
```
这个 cell，正是由 View 直接来调用 Model，所以事实上 MVC 的原则已经违背了，但是这种情况是一直发生的甚至于人们不觉得这里有哪些不对。如果严格遵守 MVC 的话,你会把对 cell 的设置放在 Controller 中，不向 View 传递一个 Model 对象，这样就会大大减少 Controller 的体积。Cocoa 的 MVC 被写成 Massive View Controller 是不无道理的。

直到进行单元测试的时候才会发现问题越来越明显。因为你的 ViewController 和 View 是紧密耦合的，对它们进行测试就显得很艰难 —— 你得有足够的创造性来模拟 View 和它们的生命周期,在以这样的方式来写 View Controller 的同时，业务逻辑的代码也逐渐被分散到 View 的布局代码中去。

- **MVC 自身的不足**

MVC 是一个用来组织代码的权威范式，也是构建 iOS App 的标准模式。Apple 甚至是这么说的。在 MVC 下，所有的对象被归类为一个 model，一个 view，或一个 controller。Model 持有数据，View 显示与用户交互的界面，而 View Controller 调解 Model 和 View 之间的交互。然而，随着模块的迭代我们越来越发现 MVC 自身存在着很多不足。

1）MVC 在现实应用中的不足：

在 MVC 模式中 view 将用户交互通知给控制器。view 的控制器通过更新 Model 来反应状态的改变。Model（通常使用 Key-Value-Observation）通知控制器来更新他们负责的 view。大多数 iOS 应用程序的代码使用这种方式来组织。

2）愈发笨重的 Controller：

在传统的 app 中模型数据一般都很简单，不涉及到复杂的业务数据逻辑处理，客户端开发受限于它自身运行的的平台终端，这一点注定使移动端不像 PC 前端那样能够处理大量的复杂的业务场景。然而随着移动平台的各种深入，我们不得不考虑这个问题。传统的 Model 数据大多来源于网络数据，拿到网络数据后客户端要做的事情就是将数据直接按照顺序画在界面上。随着业务的越来越来的深入，我们依赖的 service 服务可能在大多时间无法第一时间满足客户端需要的数据需求，移动端愈发的要自行处理一部分逻辑计算操作。这个时间一惯的做法是在控制器中处理，最终导致了控制器成了垃圾箱，越来越不可维护。

控制器 Controller 是 app 的 “胶水代码”，协调模型和视图之间的所有交互。控制器负责管理他们所拥有的视图的视图层次结构，还要响应视图的 loading、appearing、disappearing 等等，同时往往也会充满我们不愿暴露的 Model 的模型逻辑以及不愿暴露给视图的业务逻辑。这引出了第一个关于 MVC 的问题...

视图 view 通常是 UIKit 控件（component，这里根据习惯译为控件）或者编码定义的 UIKit 控件的集合。进入 .xib 或者 Storyboard 会发现一个 app、Button、Label 都是由这些可视化的和可交互的控件组成。View 不应该直接引用 Model，并且仅仅通过 IBAction 事件引用 controller。业务逻辑很明显不归入 view，视图本身没有任何业务。

厚重的 View Controller 由于大量的代码被放进 viewcontroller，导致他们变的相当臃肿。在 iOS 中有的 view controller 里绵延成千上万行代码的事并不是前所未见的。这些超重 app 的突出情况包括：厚重的 View Controller 很难维护（由于其庞大的规模）；包含几十个属性，使他们的状态难以管理；遵循许多协议（protocol），导致协议的响应代码和 controller 的逻辑代码混淆在一起。

厚重的 view controller 很难测试，不管是手动测试或是使用单元测试，因为有太多可能的状态。将代码分解成更小的多个模块通常是件好事。

3）太过于轻量级的 Model：

早期的 Model 层，其实就是如果数据有几个属性，就定义几个属性，ARC 普及以后我们在 Model 层的实现文件中基本上看不到代码（无需再手动管理释放变量，Model 既没有复杂的业务处理，也没有对象的构造，基本上 .m 文件中的代码普遍是空的）；同时与控制器的代码越来厚重形成强烈的反差，这一度让人不禁对现有的开发设计构思有所怀疑。

4）遗失的网络逻辑：

苹果使用的 MVC 的定义是这么说的：所有的对象都可以被归类为一个 Model，一个 view，或是一个控制器。就这些，那么把网络代码放哪里？和一个 API 通信的代码应该放在哪儿？

你可能试着把它放在 Model 对象里，但是也会很棘手，因为网络调用应该使用异步，这样如果一个网络请求比持有它的 Model 生命周期更长，事情将变的复杂。显然也不应该把网络代码放在 view 里，因此只剩下控制器了。这同样是个坏主意，因为这加剧了厚重控制器的问题。那么应该放在那里呢？显然 MVC 的 3 大组件根本没有适合放这些代码的地方。

5）较差的可测试性

MVC 的另一个大问题是，它不鼓励开发人员编写单元测试。由于控制器混合了视图处理逻辑和业务逻辑，分离这些成分的单元测试成了一个艰巨的任务。大多数人选择忽略这个任务，那就是不做任何测试。

上文提到了控制器可以管理视图的层次结构；控制器有一个 “view” 属性，并且可以通过 IBOutlet 访问视图的任何子视图。当有很多 outlet 时这样做不易于扩展，在某种意义上，最好不要使用子视图控制器（child view controller）来帮助管理子视图。在这里有多个模糊的标准，似乎没有人能完全达成一致。貌似无论如何，view 和对应的 controller 都紧紧的耦合在一起，总之，还是会把它们当成一个组件来对待。Apple 提供的这个组件一度以来在某种程度误导了大多初学者，初学者将所有的视图全部拖到 xib 中，连接大量的 IBoutLet 输出口属性，都是一些列问题。

- **Fat Model or Slim Model ?**

胖Model包含了部分弱业务逻辑。胖Model要达到的目的是，Controller从胖Model这里拿到数据之后，不用做额外的操作或者只做非常少的操作就能将数据应用在View上。
FatModel做了这些弱业务之后，Controller可以变得相对skinny一点，它只需要关注强业务代码。而强业务变动的可能性要比弱业务大得多，弱业务相对稳定，所以弱业务塞给Model不会有太大问题。另一方面，弱业务重复出现的频率要大于强业务，对复用性要求更高，如果这部分业务写在Controller，会造成代码冗余，类似的代码会洒得到处都是，而且一旦弱业务有修改，你就会需要修改所有地方。如果塞到了Model中，就只需要改Model就够了。
但是胖Mpdel也不是就是没有缺点的，它的缺点就在于胖Model相对比较难移植，虽然只是包含弱业务，但是它毕竟也是业务，迁移的时候很容易拔出罗布带出泥，也就是说它耦合了它的业务。而且软件是会成长的，FatModel也很有可能随着软件的成长越来越Fat，最后难以维护。

瘦Model只负责业务数据的表达，所有业务无论强弱一律人给Controller。瘦Model要达到的目的是，尽一切可能去编写细粒度Model，然后配套各种helper类或者方法来对弱业务做抽象，强业务依旧交给Controller。
由于Slim Model跟业务完全无关，它的数据可以交给任何一个能处理它数据的Helper或其他的对象，来完成业务。在代码迁移的时候独立性很强，很少会出现拔出萝卜带出泥的情况。另外，由于SlimModel只是数据表达，对它进行维护基本上是0成本，软件膨胀得再厉害，SlimModel也不会大到哪儿去。缺点就在于，Helper这种做法也不见得很好，由于Model的操作会出现在各种地方，SlimModel很容易出现代码重复，在一定程度上违背了DRY（Don’t Repeat Yourself）的思路，Controller仍然不可避免在一定程度上出现代码膨胀。

> [MVP](https://en.wikipedia.org/wiki/Model–view–presenter)

![Passive View](https://upload-images.jianshu.io/upload_images/10593309-cc0dd3824123c225.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

MVP是View驱动的,View层持有一个对应Presenter的引用,View上的交互事件首先会调用Presenter提供的接口,然后Presenter调用Model提供的方法取得数据,最后Presenter将取得的数据传递到View上展示.

MVC则是由Controller驱动的,Controller持有View,并响应View上的交互事件,根据交互调用不同的Model方法取得反馈数据,再将数据传递给View展示.

MVP是用户视角:所见即View.
MVC则是程序员视角:I control everyone.

作为一名移动端开发者,我对软件质量的追求是稳定,流畅,可扩展.

无论我们使用何种架构进行开发, 目的都可以总结为两点: 缩短开发周期(不加班),降低维护成本(不加班).

MVP上承MVC, 下启MVVM, 可以说理解了MVP,就对整个MV(X)模式有了一个基本的了解.

在我现阶段的理解中, MVP其实并不是一种软件架构模式, 而是为了解决GUI开发过程中代码组织和职责规划的问题才总结出来的一套开发方法. MVP解决的只是”用户交互”-“数据处理”-“界面更新”这三者之间的问题.

1、Model: 数据层, 从本地数据库或者服务器获取并处理数据, 然后将数据反馈给presenter;
2、Presenter: 业务处理层, 接收处理View传递过来的用户交互事件, 从Model层获取数据后进行业务逻辑处理, 然后更新View;
3、View: 展示层, 将所有的交互事件传递给presenter处理, 自身只提供更新数据的接口(对iOS来说, ViewController显示也属于View层).

整个交互流程看起来大致是这样的:

```
用户交互 -> View获得交互事件 -> View将事件转发给Presenter -> Presenter调用Model获取新数据 -> Presenter将数据推送给View进行展示
```

严格来说, 三者之间的交互应该全部通过Interface来完成, 但在实际的开发中, 为了减少代码量, 有时会直接在.h文件中定义某些交互方法. 但是”Presenter将数据推送给View进行展示”这一层的交互应该严格使用Interface来完成.

- **CAB（Componsable Application Block）基于14条MVP规则**

1、所有的View（包括View的接口）的名称应该以View作为后缀，比如TaskView/ITaskView；

2、所有的Presenter名称应该以Presenter作为后缀，比如TaskViewPresenter；

3、Presenter完成Use Case处理逻辑，对GUI控件的处理应该在View中实现；

4、View调用Presenter的方法应该像触发事件异常，通过调用OnXxx方法的方式来实现；

5、应该尽可能地限制View对Presenter的调用，并且调用的方式限于按照“事件”的形式，比如_presenter.OnViewReady();

6、View不允许通过Presenter直接调用Model和Service，并且Presenter的方法应该是不具有返回值的；

7、Presenter必须通过View接口的方式调用View

8、除了对View接口成员的实现外，View中的其他方法不应该是public的；

9、除了CAB ModuleController 对View的加载和限制外，View只能被Presenter调用；

10、View接口方法应该基于Use Case的逻辑起一个有意义的名称，比如SetDataSource这样的方法名称是不合法的；

11、View接口的成员应该仅限于方法，不应该包含属性；

12、所有的数据应用保持在Model中

13、定义在View接口的方法不应该包含对GUI空间名称的引用（比如AddExplorerBarGroup），因为这会使Presenter知道View太多关于实现方面的细节；

14、尽量让View的方法名称反映Use Case的业务逻辑，这样可以使你的代码具有自表述性并更加易于理解。

- **使用MVP中遇到的问题**

1、V-P交互

View没有处理用户交互事件的能力, 而是将交互事件转发给Presenter进行处理, 注意上面的例子, Presenter暴露给View调用的方法应该都是没有返回值的, 更不能使用block回调. Presenter在业务逻辑处理完成后, 通过Interface将数据推送给View进行更新展示.

否则就犯了最常见的错误, 将Presenter单纯的当做View调用Model的一个中介, 那此时的Presenter仅仅是一个Proxy而已. 失去了使用MVP的意义, 无法对Presenter进行不依赖UI环境的单元测试, View也丧失了复用性.

2、P-P交互

另一种常见情况是当父子视图都存在各自的Presenter时, 子视图获取了用户交互事件, 但子视图的Presenter不具备处理该交互事件的能力, 此时, 需要子视图的Presenter将交互事件传递给更上一级或多级视图的Presenter进行处理.

一个具体的场景是, 在ViewController的根View的子视图中存在用户交互, 而且需要进行页面跳转, 但是继承自UIView的自定义控件是不能使用modal或push方法的. 这时就需要将事件传递到拥有页面跳转能力的根ViewController. 所以在根ViewController要实现的Interface中会包含一个@require的方法负责跳转, 其Presenter接受子视图发出的页面跳转通知, 参数就是已经包装好的目标界面, 然后调用View的相关方法实现跳转.

3、V-V交互

View和View的交互更多体现在动画场景中. 比如,两个view需要进行联动, 其中一个view接收到用户交互之后frame会发生变化(width收缩), 而另一个view的x是相对于第一个view的width布局的.

在这种情况下, 由于MVP的响应事件应该严格规范到相应的presenter中, 如果不涉及到业务逻辑, 两个view的Presenter通过通知进行沟通, 同步两者的收缩或展开(这时两个view的Interface中都会有shrink和expansion两个方法).

如果这两个view的状态和某个业务逻辑参数相关(比如关注状态), 则应该通过持有该状态的Model发出业务状态改变的通知, 各个presenter接受该参数, 然后处理各自的状态, 这样两个需要联动的view之间就不需要直接通讯了.

> [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel)

![MVVM](https://upload-images.jianshu.io/upload_images/10593309-2d81e73bf3ebb939.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[MVVM](https://en.wikipedia.org/wiki/Model_View_ViewModel) 是 Model-View-ViewModel 的简写。

相对于 MVC 的历史来说，MVVM 是一个相当新的架构，MVVM 最早于 2005 年被微软的 WPF 和 Silverlight 的架构师 John Gossman 提出，并且应用在微软的软件开发中。当时 MVC 已经被提出了 20 多年了，可见两者出现的年代差别有多大。

![MVVM](https://upload-images.jianshu.io/upload_images/10593309-b5c800d355f2dbdf.gif?imageMogr2/auto-orient/strip)

ViewModel: 相比较于MVC新引入的视图模型。是视图显示逻辑、验证逻辑、网络请求、数据读取等代码存放的地方，唯一要注意的是，任何视图本身的引用都不应该放在VM中，换句话说就是VM中不要引入UIKit.h (对于image这个，也有人将其看做数据来处理，这就看个人想法了，并不影响整体的架构)。

这样，首先解决了VC臃肿的问题，将逻辑代码、网络请求等都写入了VM中，然后又由于VM中包含了所有的展示逻辑而且不会引用V，所以它是可以通过编程充分测试的。

- **双向绑定**

MVVM 在使用当中，通常还会利用双向绑定技术，使得 Model 变化时，ViewModel 会自动更新，而 ViewModel 变化时，View 也会自动变化。所以，MVVM 模式有些时候又被称作：[model-view-binder](https://en.wikipedia.org/wiki/Model_View_ViewModel) 模式。

在iOS平台上面有KVO和通知，但是用起来总是觉得不太方便，所以有一些三方库供我们选择：

1、基于KVO的绑定库，如[Facebook's KVOController](https://github.com/facebook/KVOController)、 [RZDataBinding](https://link.jianshu.com?t=https://github.com/Raizlabs/RZDataBinding) 、 [SwiftBond](https://link.jianshu.com?t=https://github.com/SwiftBond/Bond)
2、使用全量级的 [函数式响应编程](https://halfrost.com/functional_reactive_programming_concept/) 框架,比如[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)、[ReactiveObjC](https://github.com/ReactiveCocoa/ReactiveObjC)、[ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)、[RxSwift](https://github.com/ReactiveX/RxSwift/) 、[PromiseKit](https://github.com/mxcl/PromiseKit)

实际上，我们在提到MVVM的时候就很容易想到ReactiveCocoa，它也是我们在iOS中使用MVVM的最好工具。但是相对来说它的学习成本和维护成本 也是比较高的，而且一旦你应用不当，很可能造成灾难性的问题。

> [VIPER](https://www.objc.io/issues/13-architecture/viper/)

VIPER 是我们最后的备选，它比较特别，因为它不是从MV(X)扩展出来的。

现在，你必须同意，细力度的责任划分是非常好的。VIPER又一次迭代了责任划分，这里，我们有五个层次。
![VIPER](https://upload-images.jianshu.io/upload_images/10593309-9f53c9df6b05dca5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- Interactor - 包括数据实体、业务逻辑、网络请求等，如创建新的实例，或者从服务器获取实例。为达到这一目的而使用的一些服务或管理，不被视为VIPER的一部分，而是作为一些外部依赖。
- Presenter - 包括UI相关(但不包括UIKit相关)的业务逻辑，调用了Interactor的方法。
- Entities - 你的数据对象，而不是数据访问层，因为那是Interactor的责任。
- Router - 负责VIPER模块之间的连接。

当你开始使用VIPER时，你可能会有用乐高积木来建造帝国大厦的感觉，这通常是你的设计有问题的信号。也许，这是你太早采用VIPER了(粒度太细)，你应该考虑一些更简单的东西。有些人忽略这一点，并继续用大炮打蚊子。我想他们是认为当前阶段使用VIPER会在未来获益，即便当前维护成本有点高也可以接受。如果你认同这个观点，那么我建议你尝试[Generamba](https://github.com/rambler-ios/Generamba) －生成VIPER框架的工具。我个人觉得这就像是是用自动瞄准系统的火炮取代弹弓。


> Conclusion

我们了解了集中架构模式，希望你已经找到了到底是什么在困扰你。毫无疑问通过阅读本篇文章，你已经了解到其实并没有完全的银弹。所以选择架构是一个根据实际情况具体分析利弊的过程。
因此，在同一个应用中包含着多种架构。比如，你开始的时候使用MVC，然后突然意识到一个页面在MVC模式下的变得越来越难以维护，然后就切换到MVVM架构，但是仅仅针对这一个页面。并没有必要对哪些MVC模式下运转良好的页面进行重构，因为二者是可以并存的。

> **[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 的初步了解以及基本使用**

RAC是提供事件流，通过信号源和信号源提供者（产生者），信号接受者协和来完成。 
借用面向对象的一句话，万物皆是流的形式，通过一方发出信号，一方接受信号来完成不同事件。

我们所熟知的iOS 开发中的事件包括：

*代理方法
block 回调
通知
行为控制和事件的响应链
协议
KVO*
……

而 ReactiveCocoa ，就是用信号接管了 iOS 中的所有事件；也就意味着，用一种统一的方式来处理iOS中的所有事件，解决了各种分散的事件处理方式，显然这么一个庞大的框架学习起来也会比较难！而且如果习惯了iOS原生的编程，可能会觉得不习惯！

**优点**
高内聚，低耦合

**响应式编程思想**
不需要考虑调用顺序，只需要知道考虑结果，类似于蝴蝶效应，产生一个事件，会影响很多东西，这些事件像流一样的传播出去，然后影响结果，借用面向对象的一句话，万物皆是流。

**函数式编程思想**
把操作尽量写成一系列嵌套的函数或者方法调用。 
特点：每个方法必须有返回值（本身对象）,把函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）。

**ReactiveCocoa编程风格**
ReactiveCocoa结合了 函数式编程（Functional Programming）和 响应式编程（Reactive Programming）各自的优点，产生一种新的语法

**ReactiveCocoa常见类**

1、RACSignal (核心)
RACSignal:信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。
```
 // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block。

        // 2.发送信号
        [subscriber sendNext:@"我是一个信号类"];
        // 如果不再发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
        return [RACDisposable disposableWithBlock:^{
            // 执行完Block后，当前信号就不再被订阅了。
            NSLog(@"信号被销毁");
        }];
    }];
    self.signal = signal;

    // 3.订阅信号,才会激活信号
    [signal subscribeNext:^(id x) {
        NSLog(@"接收的数据：%@",x);
    }];
```

2、RACSubscriber
表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。

3、RACDisposable
用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
```
[RACDisposable disposableWithBlock:^{
    // 执行完Block后，当前信号就不再被订阅了。
    NSLog(@"信号被销毁");
}];
```
4、RACSubject
RACSubject:信号提供者，自己可以充当信号，又能发送信号。 
RACSubject使用步骤：
1. 创建信号 [RACSubject subject]，跟RACSignal不一样，创建信号时没有block。
2. 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
3. 发送信号 sendNext:(id)value
```
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者：%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者：%@",x);
    }];
    // 3.发送信号
    [subject sendNext:@"发送信号"];
```

**ReactiveCocoa常见用法**

*Event*
```
    // 监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮被点击");
    }];
```

*KVO观察者*
```
    // 监听对象的属性值改变，转换成信号，只要值改变就会发送信号
    [[View rac_valuesAndChangesForKeyPath:@"x" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"view的x值发生了改变");
    }];
```
*Notification通知*
```
    // 代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘将要出现");
    }];

    // 通过RAC提供的宏快速实现观察者模式
    // RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    [RACObserve(self.greenView,x) subscribeNext:^(id x) {
        NSLog(@"绿色view的x方向发生改变");
    }];
```
*textField的文字信号*
```
    // 监听文本框的文字改变
    [[_textField rac_textSignal] subscribeNext:^(NSString *x) {
        NSLog(@"文本框文字发生了改变：%@",x);
    }];

    // 通过RAC提供的宏快速实现textSingel的监听
    // RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    // 当textField的文字发生改变时，label的文字也发生改变
    RAC(self.textLabel,text) = self.textField.rac_textSignal;
```
*手势信号*
```
    // 监听手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"view被触发tap手势");
    }];
    [self.view addGestureRecognizer:tapGesture];
```
*过滤器filter*
```
    // 过滤器
    [[self.textField.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length >= 3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
```
*忽略信号*
```
// 内部调用filter过滤，忽略掉ignore的值
 [[self.textfield1.rac_textSignal ignore:@"123"] subscribeNext:^(id x) {
     NSLog(@"%@",x);
 }];
```
*忽略不变的信号*
```
    ACSubject *subject = [RACSubject subject];
    //当上一次的值和这次的值有明显变化的时候就会发出信号，否则会忽略掉
    //一般用来刷新UI界面，当数据有变化的时候才会刷新
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"123456"];
    [subject sendNext:@"12346”];
```
*取前面指定次数的信号*
```
    RACSubject *subject = [RACSubject subject];
    //只取前两次的信号
    [[subject take:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"123456"];
    [subject sendNext:@"12346"];
    [subject sendNext:@"123456"];
    [subject sendNext:@"12346”];
```
*取最后指定次数的信号*
```
    //takeLast:取最后N次的信号，前提条件订阅者必须调用完成，因为只有完成才知道一共有多少信号
    RACSubject *subject = [RACSubject subject];
    //只取最后两次的信号
    [[subject takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"123456"];
    [subject sendNext:@"12346"];
    [subject sendNext:@"last1"];
    [subject sendNext:@"last2"];
    [subject sendCompleted];//订阅者必须调用完成
```
*跳过几个信号*
```
  // 输入第一次不会被监听到，跳过第一次发出的信号
  [[self.textfield1.rac_textSignal skip:1] subscribeNext:^(id x) {
      NSLog(@"%@",x);
  }];
```
*执行秩序*
```
    // doNext: 执行Next之前，会先执行这个Block
    // doCompleted：: 执行sendCompleted之前，会先执行这个Block
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"100"];
        [subscriber sendCompleted];
        NSLog(@"发送完毕");
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@100];之前会调用这个Block
         NSLog(@"doNext%@",x);
    }] doCompleted:^{
        //执行[subscriber sendCompleted];之前调用这个block
         NSLog(@"doCompleted");;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];

    /*
     输出：
     2016-05-18 15:42:53.720 ReactiveCocoaTest1[4966:252147] doNext100
     2016-05-18 15:42:53.720 ReactiveCocoaTest1[4966:252147] 100
     2016-05-18 15:42:53.720 ReactiveCocoaTest1[4966:252147] doCompleted
     2016-05-18 15:42:53.720 ReactiveCocoaTest1[4966:252147] 发送完毕
     */
```
*超时报错*
```
   RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      [subscriber sendNext:@"100"];
      return nil;
   }] timeout:1 onScheduler: [RACScheduler currentScheduler]];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"1秒后会自动调用");
    }];
```
*定时发送*
```
    //每隔一秒钟就会发出信号

     [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {

         NSLog(@"%@",x);

     }];
```
*延时发送*
```
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [subscriber sendNext:@"100"];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        //调用[subscriber sendNext:@"100"] 2秒之后执行这个block
        NSLog(@"%@",x);
    }];
```
*重试*
```
    // retry:重试，只要失败，就会重新执行创建信号中的block,直到成功
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
    }];
```
*反复*
```
    //replay重放：当一个信号被多次订阅,反复播放内容
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }] replay];
    [signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
```
*节流*
```
    // throttle节流 ：当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
     RACSubject *signal = [RACSubject subject];
    _signal = signal;
    // 节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[signal throttle:1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal sendNext:@"100"];
    [signal sendNext:@"1000"];
```
> Demo (仅供参考)

[Demo地址](https://github.com/MountainXiang/iOS-ArchitecturalPattern) 
*赠人star，手有余香~*

> 参考

[Concepts in Objective-C Programming](https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Model-View-Controller/Model-View-Controller.html)
[杂谈: MVC/MVP/MVVM](https://www.jianshu.com/p/eedbc820d40a)
[iOS - MVC 架构模式](https://www.cnblogs.com/QianChia/p/5771082.html)
[8 Patterns to Help You Destroy Massive View Controller](http://khanlou.com/2014/09/8-patterns-to-help-you-destroy-massive-view-controller/?utm_source=wanqu.co&utm_campaign=Wanqu+Daily&utm_medium=social)
[iOS基于MVC的项目重构总结](http://www.cocoachina.com/ios/20160519/16346.html)
[再谈MVP模式](http://www.cocoachina.com/ios/20170320/18927.html)
[大话MVP](https://www.cnblogs.com/artech/archive/2010/04/12/1710681.html)
[Design Rules for Model-View-Presenter](https://www.cnblogs.com/artech/archive/2010/04/12/1710337.html)
[被误解的 MVC 和被神化的 MVVM](http://blog.devtang.com/2015/11/02/mvc-and-mvvm/ "被误解的 MVC 和被神化的 MVVM")
[iOS架构模式——MV(X)的理解与实战](https://www.jianshu.com/p/c19969c97a4a)
[iOS 关于MVVM Without ReactiveCocoa设计模式的那些事](https://www.jianshu.com/p/db8400e1d40e)
[iOS MVVM+RAC 从框架到实战](https://www.jianshu.com/p/3beb21d5def2)
[iOS-ReactiveCocoa(RAC)的初步了解以及基本使用](https://blog.csdn.net/Mazy_ma/article/details/52210952)
[ReactiveCocoa操作方法(过滤，秩序,时间，重复)](https://blog.csdn.net/u013232867/article/details/51532715)
[ReactiveCocoa vs RxSwift - pros and cons?](https://stackoverflow.com/questions/32542846/reactivecocoa-vs-rxswift-pros-and-cons)
[MVVM奇葩说](http://www.cocoachina.com/ios/20160520/16004.html)
[面向协议的 MVVM 架构介绍](https://realm.io/cn/news/doios-natasha-murashev-protocol-oriented-mvvm/)
[MVVM With ReactiveCocoa](http://www.cocoachina.com/ios/20160330/15823.html)
[更轻量的 View Controllers](https://www.objc.io/issue-1/lighter-view-controllers.html)
[ReactiveCocoa 和 MVVM 入门](http://yulingtianxia.com/blog/2015/05/21/ReactiveCocoa-and-MVVM-an-Introduction/)
[MVVM 介绍](http://objccn.io/issue-13-1/)
[写给iOS小白的MVVM教程(序)](http://www.ios122.com/2015/10/mvvm_start/)
[多方位全面解析：如何正确地写好一个界面](http://ios.jobbole.com/83657/)
[iOS应用架构谈 view层的组织和调用方案](http://www.cocoachina.com/ios/20150525/11919.html)
[用Model-View-ViewModel构建iOS App](http://www.cocoachina.com/ios/20140716/9152.html)
[浅谈iOS中MVVM的架构设计与团队协作](http://www.cocoachina.com/ios/20150122/10987.html)
[一次简单的 ViewModel 实践](http://bifidy.net/index.php/407)
[不要把ViewController变成处理tableView的"垃圾桶"](http://www.cocoachina.com/ios/20151218/14743.html)
[实践干货！猿题库 iOS 客户端架构设计](http://www.cocoachina.com/ios/20160108/14911.html)
[iOS架构实践干货：AOP替代基类 + MVVM + ReactiveObjC + JLRoutes组件化](https://www.jianshu.com/p/921dd65e79cb)
[iOS架构模式-揭秘MVC,MVP,MVVM和VIPER](https://blog.csdn.net/cuibo1123/article/details/50681389)
