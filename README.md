<div style="text-align: center; margin: 0 auto;">

# 没必要签到
一个支持插件签到的通用校园考勤位置签到APP,使用Flutter进行开发

![Version](https://img.shields.io/badge/版本-0.0.3-green)
![License](https://img.shields.io/badge/许可-LGPL-yellow)
![Author](https://img.shields.io/badge/作者-TaoEngine-brown?logo=github)
![Code](https://img.shields.io/badge/基于-Flutter-blue?logo=flutter)
![Plugin](https://img.shields.io/badge/基于-TOML-red?logo=toml)
![Contact](https://img.shields.io/badge/交流-3214124547-white?logo=tencent-qq)

</div>

> [!WARNING]
> 此项目含有部分功能作为作者学习研究所用,这些功能可能会违反当地学校的某些规定[^1],因此暂时被注释掉了,如果你需要这些功能可以自行反注释代码达到目的,但使用这些功能所造成的责任划定与作者无关

> [!IMPORTANT]
> 此项目为通用型位置签到客户端,并不单单适用于某一所学校,因此你们也可以根据自己学校的RESTful格式编写自己的签到插件[^2]

## 介绍
这是一款能够自定义签到方式的校园考勤位置签到的APP,只因作者实在受不了学校官方弄的签到公众号,又卡又不稳定,有时候还签不上,于是另起炉灶自己按照抓包来的RESTFul格式编写了这款好看又强大的签到APP

## 使用
我希望这款APP能让你不必打开多个APP就能完成有关校园的签到活动,你只需要这样做:
- 初次打开APP时先进入设置登录学号和密码
- 然后下一次打开APP就点右上角的"签到"按钮就行了

这款APP的下一步规划是后台签到,你只需要设置签到时间范围,并且你在签到位置范围,它就会自动帮你签到并给出简短的提醒,签到失败会给出强提醒

## 许可
#### 禁止商用!
这款APP没有任何盈利行为(捐赠不算),并且我不希望有人拿这个东西去赚钱,搞盈利会很快被学校的人盯上的😥

#### 它是免费的!
如果你是买来的这款应用,你很可能被骗了!你可以把商家发给我,我来在APP首页公布这种行为☝️🤓

#### 记得不要忘了我的贡献
假如你用核心模块制作了属于自己的应用,请务必在关于界面上提一嘴"这款APP的核心是由TaoEngine开发的",我会非常感谢你的🤗

> [!IMPORTANT]
> 如果你不能能做到这些点,那么请你卸载我的软件并选用其他签到方案.这话是给君子说的

## 关注&捐赠

<table style="text-align: center; margin: 0 auto; width: 500;">
    <tr>
        <th>
          <img src="./img/findme.png" width="200" alt="觉得我做的东西有点意思,要不趁机认识一下我?" style="display: block; margin: 0 auto;"/>
        </th>
        <th>
          <img src="./img/donate.png" width="200" alt="虽然我觉得我的项目很简单,但是如果你能慷慨捐赠我将会更加努力的" style="display: block; margin: 0 auto;"/>
        </th>
    </tr>
    <tr>
        <td>
          <p>
            觉得我做的东西有点意思,<br>
            要不趁机认识一下我?
          </p>
        </td>
        <td>
        <p>
          虽然我觉得项目很简单,<br>
          但是如果你能慷慨捐赠<br>
          我将会更有动力的
        </p>
        </td>
    </tr>
</table>

[^1]:作者只为本人所在的学校开发了对应的扩展插件,签到客户端并非针对此学校进行开发
[^2]:具体扩展开发模板可以去参照此项目的Wiki(正在做)