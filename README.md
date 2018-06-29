# BroadcastView
用Swift4.2写的首页轮播View
```
       let view = MMBroadcastView(frame: CGRect(x: 0, y: 65, width: self.view.bounds.size.width, height: 200))
        view.delegate = self
        view.backgroundColor = UIColor.cyan
        self.view.addSubview(view)
        view.images = ["imageURL"]
```

```
extension TestViewController:MMBroadcastViewDelegate
{
    func BroadcastViewTaped(_ index: Int) {
        print("点击了第\(index)个Item")
    }
}
```
![image](https://github.com/linlingliu/BroadcastView/blob/master/轮播.gif)
