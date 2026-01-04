/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { AccountStore, AuthState } from '../store/account.store';

@Entry
@Component
struct AccountPage {
  @StorageLink('topRectHeight') topRectHeight: number = 0;
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0;

  @State private authState: AuthState = { isLogin: false };
  @State private activeTab: string = 'login';
  @State private feedback: string = '';

  @State private loginAccount: string = '';
  @State private loginPassword: string = '';

  @State private registerNickname: string = '';
  @State private registerPhone: string = '';
  @State private registerEmail: string = '';
  @State private registerPassword: string = '';
  @State private registerConfirm: string = '';

  aboutToAppear(): void {
    this.refreshAuth();
  }

  private refreshAuth(): void {
    this.authState = AccountStore.getAuthState();
  }

  private showToast(message: string): void {
    try {
      this.getUIContext().getPromptAction().showToast({ message });
    } catch {
    }
  }

  private submitLogin(): void {
    const result = AccountStore.login(this.loginAccount, this.loginPassword);
    if (!result.success) {
      this.feedback = result.error ?? '登录失败，请重试';
      return;
    }
    this.feedback = '登录成功';
    this.refreshAuth();
    this.showToast('欢迎回来');
  }

  private submitRegister(): void {
    if (this.registerPassword !== this.registerConfirm) {
      this.feedback = '两次输入的密码不一致';
      return;
    }
    const result = AccountStore.register(this.registerNickname, this.registerPhone, this.registerEmail, this.registerPassword);
    if (!result.success) {
      this.feedback = result.error ?? '注册失败，请重试';
      return;
    }
    this.feedback = '注册成功，已自动登录';
    this.clearRegisterForm();
    this.refreshAuth();
    this.showToast('注册成功');
  }

  private clearRegisterForm(): void {
    this.registerNickname = '';
    this.registerPhone = '';
    this.registerEmail = '';
    this.registerPassword = '';
    this.registerConfirm = '';
  }

  private logout(): void {
    AccountStore.logout();
    this.refreshAuth();
    this.feedback = '已退出登录';
  }

  private getDisplayName(): string {
    if (this.authState.isLogin && this.authState.profile) {
      return this.authState.profile.nickname;
    }
    return '请登录 / 注册';
  }

  private getContact(): string {
    if (this.authState.isLogin && this.authState.profile) {
      const phone: string | undefined = this.authState.profile.phone;
      const email: string | undefined = this.authState.profile.email;
      if (phone && email) {
        return `${phone} · ${email}`;
      }
      return phone ?? email ?? '完善手机号或邮箱，便于找回密码';
    }
    return '登陆后同步订单、优惠券、积分';
  }

  private calBadgeValue(seed: number): number {
    if (!this.authState.isLogin || !this.authState.profile) {
      return 0;
    }
    return (Math.abs(seed + this.authState.profile.createdAt) % 9) + 1;
  }

  build() {
    Column() {
      this.buildContent()
      this.buildNavBar()
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.home_background_color'))
  }

  @Builder
  private buildContent(): void {
    Scroll() {
      Column() {
        Blank().height(this.getUIContext().px2vp(this.topRectHeight))

        this.buildProfileHeader()

        this.buildStatsCard()

        this.buildQuickActions()

        if (!this.authState.isLogin) {
          this.buildAuthCard()
        } else {
          this.buildSecurityCard()
        }

        Blank().height(12 + this.getUIContext().px2vp(this.bottomRectHeight) / 2)
      }
      .width(Const.FULL_WIDTH)
      .padding({ left: 12, right: 12, top: 12 })
    }
    .layoutWeight(1)
    .width(Const.FULL_WIDTH)
  }

  @Builder
  private buildProfileHeader(): void {
    Column() {
      Row() {
        Column() {
          Text(this.getDisplayName())
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)

          Text(this.getContact())
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Gray)
            .margin({ top: 4 })

          Row({ space: 6 }) {
            this.buildTag('会员', '#FCE4EA')
            this.buildTag('安全', '#E8F5E9')
          }
          .margin({ top: 6 })
        }
        .layoutWeight(1)

        Column() {
          Button(this.authState.isLogin ? '退出' : '登录')
            .height(32)
            .backgroundColor($r('app.color.focus_color'))
            .fontColor(Color.White)
            .borderRadius(16)
            .padding({ left: 12, right: 12 })
            .onClick(() => {
              if (this.authState.isLogin) {
                this.logout();
              } else {
                this.activeTab = 'login';
                this.feedback = '';
              }
            })

          Row() {
            Text(this.getAvatarText())
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .width(48)
          .height(48)
          .backgroundColor($r('app.color.focus_color'))
          .borderRadius(24)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 8 })
        }
        .alignItems(HorizontalAlign.End)
      }
      .width(Const.FULL_WIDTH)
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 14, right: 14, top: 8, bottom: 8 })
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  private getAvatarText(): string {
    if (this.authState.isLogin && this.authState.profile) {
      const name: string = this.authState.profile.nickname;
      return name.length > 0 ? name[0].toUpperCase() : '?';
    }
    return '?';
  }

  @Builder
  private buildTag(label: string, color: string): void {
    Text(label)
      .fontSize($r('app.float.smaller_font_size'))
      .fontColor(Color.Black)
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .backgroundColor(color)
      .borderRadius(12)
  }

  @Builder
  private buildStatsCard(): void {
    Column() {
      Row({ space: 12 }) {
        this.statItem('待支付', `${this.calBadgeValue(2)}`)
        this.statItem('优惠券', `${this.calBadgeValue(5)}`)
        this.statItem('积分', `${this.calBadgeValue(8) * 100}`)
      }
      .width(Const.FULL_WIDTH)
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
  }

  @Builder
  private statItem(label: string, value: string): void {
    Column() {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
      Text(label)
        .fontSize($r('app.float.smaller_font_size'))
        .fontColor(Color.Gray)
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .padding({ top: 4, bottom: 4 })
    .backgroundColor('#F7F7F9')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private buildQuickActions(): void {
    Column() {
      Row() {
        Text('常用入口')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.Black)
        Blank().layoutWeight(1)
        Text('管理地址、支付、安全等信息')
          .fontSize($r('app.float.smaller_font_size'))
          .fontColor(Color.Gray)
      }
      .width(Const.FULL_WIDTH)

      Flex({ wrap: FlexWrap.Wrap }) {
        this.quickItem('全部订单', '查看近期购买', () => this.showToast('订单列表占位'))
        this.quickItem('收货地址', '新增/编辑地址', () => this.showToast('收货地址占位'))
        this.quickItem('售后服务', '申请退换货', () => this.showToast('售后服务占位'))
        this.quickItem('账号安全', '密码和登录验证', () => {
          this.activeTab = 'login';
          this.showToast('可在下方登录/切换账号');
        })
        this.quickItem('客服与帮助', '常见问题', () => this.showToast('联系客服占位'))
        this.quickItem('设置', '通知与偏好', () => this.showToast('设置占位'))
      }
      .margin({ top: 12 })
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 16, right: 16, top: 14, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
  }

  @Builder
  private quickItem(title: string, desc: string, onClick?: () => void): void {
    Column() {
      Text(title)
        .fontSize($r('app.float.small_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
      Text(desc)
        .fontSize($r('app.float.smaller_font_size'))
        .fontColor(Color.Gray)
        .margin({ top: 4 })
    }
    .width('48%')
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .backgroundColor('#F7F7F9')
    .borderRadius(12)
    .margin({ right: 8, bottom: 8 })
    .onClick(() => onClick?.())
  }

  @Builder
  private buildAuthCard(): void {
    Column() {
      Row({ space: 12 }) {
        this.buildTab('登录', 'login')
        this.buildTab('注册', 'register')
      }
      .width(Const.FULL_WIDTH)
      .margin({ bottom: 12 })

      if (this.activeTab === 'login') {
        this.buildLoginForm()
      } else {
        this.buildRegisterForm()
      }

      if (this.feedback) {
        Text(this.feedback)
          .fontSize($r('app.float.smaller_font_size'))
          .fontColor(this.feedback.includes('成功') ? Color.Green : Color.Red)
          .margin({ top: 10 })
      }
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
  }

  @Builder
  private buildTab(label: string, key: string): void {
    Column() {
      Text(label)
        .fontSize($r('app.float.small_font_size'))
        .fontWeight(this.activeTab === key ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.activeTab === key ? $r('app.color.focus_color') : Color.Gray)
    }
    .padding({ left: 10, right: 10, top: 8, bottom: 8 })
    .backgroundColor(this.activeTab === key ? '#FCE4EA' : Color.Transparent)
    .borderRadius(12)
    .onClick(() => {
      this.activeTab = key;
      this.feedback = '';
    })
  }

  @Builder
  private buildLoginForm(): void {
    Column({ space: 10 }) {
      TextInput({ text: this.loginAccount, placeholder: '手机号或邮箱' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.loginAccount = value)

      TextInput({ text: this.loginPassword, placeholder: '密码' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.loginPassword = value)

      Button('登录')
        .height(44)
        .backgroundColor($r('app.color.focus_color'))
        .fontColor(Color.White)
        .borderRadius(22)
        .onClick(() => this.submitLogin())
    }
    .width(Const.FULL_WIDTH)
  }

  @Builder
  private buildRegisterForm(): void {
    Column({ space: 10 }) {
      TextInput({ text: this.registerNickname, placeholder: '昵称' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.registerNickname = value)

      TextInput({ text: this.registerPhone, placeholder: '手机号（可选）' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.registerPhone = value)

      TextInput({ text: this.registerEmail, placeholder: '邮箱（可选）' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.registerEmail = value)

      TextInput({ text: this.registerPassword, placeholder: '密码（至少 6 位）' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.registerPassword = value)

      TextInput({ text: this.registerConfirm, placeholder: '确认密码' })
        .height(44)
        .backgroundColor('#F7F7F9')
        .padding({ left: 12, right: 12 })
        .borderRadius(12)
        .fontSize($r('app.float.small_font_size'))
        .onChange((value: string) => this.registerConfirm = value)

      Button('注册并登录')
        .height(44)
        .backgroundColor($r('app.color.focus_color'))
        .fontColor(Color.White)
        .borderRadius(22)
        .onClick(() => this.submitRegister())
    }
    .width(Const.FULL_WIDTH)
  }

  @Builder
  private buildSecurityCard(): void {
    Column() {
      Row() {
        Text('账户与安全')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.Black)
        Blank().layoutWeight(1)
        Text('已登录')
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Gray)
      }
      .width(Const.FULL_WIDTH)

      Column({ space: 10 }) {
        this.securityRow('登录设备', '已绑定当前设备')
        this.securityRow('手机号 / 邮箱', this.getContact())
        this.securityRow('注册时间', this.authState.profile ? this.formatDate(this.authState.profile.createdAt) : '')
      }
      .margin({ top: 12 })

      Row() {
        Button('切换账号 / 重新登录')
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#F7F7F9')
          .fontColor(Color.Black)
          .borderRadius(22)
          .onClick(() => {
            this.logout();
            this.activeTab = 'login';
          })

        Button('退出登录')
          .layoutWeight(1)
          .height(44)
          .margin({ left: 12 })
          .backgroundColor($r('app.color.focus_color'))
          .fontColor(Color.White)
          .borderRadius(22)
          .onClick(() => this.logout())
      }
      .margin({ top: 14 })
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 12 })
  }

  @Builder
  private securityRow(label: string, value: string): void {
    Row() {
      Text(label)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)
      Blank().layoutWeight(1)
      Text(value)
        .fontSize($r('app.float.smaller_font_size'))
        .fontColor(Color.Gray)
        .textAlign(TextAlign.End)
    }
    .width(Const.FULL_WIDTH)
  }

  private formatDate(timestamp: number): string {
    const date: Date = new Date(timestamp);
    const year: number = date.getFullYear();
    const month: number = date.getMonth() + 1;
    const day: number = date.getDate();
    return `${year}/${month.toString().padStart(2, '0')}/${day.toString().padStart(2, '0')}`;
  }

  @Builder
  private buildNavBar(): void {
    Row() {
      this.navItem('产品', false, () => {
        try {
          this.getUIContext().getRouter().replaceUrl({ url: 'pages/HomePage' });
        } catch {
        }
      })
      this.navItem('推荐', false, () => {
        try {
          this.getUIContext().getRouter().replaceUrl({ url: 'pages/HomePage' });
        } catch {
        }
      })
      this.navItem('购物车', false, () => {
        try {
          this.getUIContext().getRouter().replaceUrl({ url: 'pages/CartPage' });
        } catch {
        }
      })
      this.navItem('账户', true, () => {})
    }
    .width(Const.FULL_WIDTH)
    .height($r('app.float.home_nav_height'))
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceAround)
    .padding({ bottom: this.getUIContext().px2vp(this.bottomRectHeight) / 2 })
  }

  @Builder
  private navItem(label: string, active: boolean, onClick?: () => void): void {
    Column() {
      Text(label)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(active ? $r('app.color.focus_color') : Color.Gray)
        .fontWeight(active ? FontWeight.Bold : FontWeight.Medium)
    }
    .width('20%')
    .height($r('app.float.home_nav_height'))
    .justifyContent(FlexAlign.Center)
    .onClick(() => onClick?.())
  }
}
