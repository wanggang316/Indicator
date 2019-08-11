# Indicator

* 支持 loading、成功提示、失败提示、信息提示、文本提示等
* 支持自定义时间隐藏
* 支持隐藏后回调
* 支持自定义提示视图

## 要求

* Swift 4.0 or later
* iOS 9.0 or later

## 安装

``` swift
pod 'GYUIComponents/Indicator'
```

## 使用

* loading
``` swift
Indicator.show(.loading, inView: view)
Indicator.show(.statefulLoading("加载中..."), inView: view)
```

* 成功提示
``` swift
Indicator.show(.success("上传成功"), inView: view, delay: 1.5) {
    // do something
}
```

* 信息提示
``` swift
Indicator.show(.info("提示信息"), inView: view, delay: 1.5) {
    // do something
}
```

* 失败提示
``` swift
Indicator.show(.error("请求失败"), inView: view, delay: 1.5) {
    // do something
}
```

* 纯文本信息提示
``` swift
Indicator.show(.text("纯文本提示"), inView: view, delay: 1.5) {
    // do something
}
```

* 隐藏
``` swift
Indicator.hide()
```

* 自定义

可通过实现 IndicatorView 协议自定义提示视图
