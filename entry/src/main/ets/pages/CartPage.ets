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
import { CartItem, CartStore } from '../store/cart.store';

const COUPON_SAVE10: string = 'SAVE10';
const COUPON_OFF20: string = 'OFF20';

interface CartSummary {
  subtotal: number;
  discount: number;
  serviceFee: number;
  shipping: number;
  tax: number;
  payable: number;
}

@Entry
@Component
struct CartPage {
  @StorageLink('topRectHeight') topRectHeight: number = 0;
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0;

  @State private items: CartItem[] = [];
  @State private selectedKeys: string[] = [];
  @State private editMode: boolean = false;

  @State private couponInput: string = '';
  @State private appliedCoupon: string = '';
  @State private couponMessage: string = '';

  private taxRate: number = 0.1;

  @State private summary: CartSummary = {
    subtotal: 0,
    discount: 0,
    serviceFee: 0,
    shipping: 0,
    tax: 0,
    payable: 0
  };

  aboutToAppear(): void {
    this.refreshItems();
  }

  private recomputeSummary(): void {
    // 关键：必须整体替换为新对象，不能只改字段
    this.summary = this.getSummary();
  }

  private refreshItems(): void {
    const nextItems: CartItem[] = CartStore.getItems().map((item: CartItem) => this.cloneCartItem(item));

    const wasAllSelected: boolean =
      (this.items.length === 0 && this.selectedKeys.length === 0) ||
      (this.items.length > 0 && this.selectedKeys.length === this.items.length);

    const nextKeySet: Set<string> = new Set<string>(nextItems.map((it: CartItem) => this.itemKey(it)));

    const selected: Set<string> = new Set<string>(
      this.selectedKeys.filter((k: string) => nextKeySet.has(k))
    );

    if (wasAllSelected) {
      nextKeySet.forEach((k: string) => selected.add(k));
    }

    this.items = nextItems;
    this.selectedKeys = Array.from(selected);

    this.recomputeSummary();
    this.updateCouponMessageOnSubtotalChange();
  }

  private cloneCartItem(item: CartItem): CartItem {
    const copy: CartItem = {
      productId: item.productId,
      skuId: item.skuId,
      skuName: item.skuName,
      name: item.name,
      price: item.price,
      image_url: item.image_url,
      count: item.count
    } as CartItem;
    return copy;
  }

  private itemKey(item: CartItem): string {
    return `${item.productId}_${item.skuId}`;
  }

  private isSelected(item: CartItem): boolean {
    return this.selectedKeys.indexOf(this.itemKey(item)) >= 0;
  }

  private setSelected(key: string, checked: boolean): void {
    const filtered: string[] = this.selectedKeys.filter((k: string) => k !== key);
    if (checked) {
      filtered.push(key);
    }
    this.selectedKeys = filtered;
    this.recomputeSummary();
    this.updateCouponMessageOnSubtotalChange();
  }

  private setSelectAll(checked: boolean): void {
    if (!checked) {
      this.selectedKeys = [];
      this.updateCouponMessageOnSubtotalChange();
      return;
    }
    this.selectedKeys = this.items.map((item: CartItem) => this.itemKey(item));
    this.recomputeSummary();
    this.updateCouponMessageOnSubtotalChange();
  }

  private parsePrice(price: string): number {
    const normalized: string = price.replace(/[^0-9.]/g, '');
    const parsed: number = parseFloat(normalized);
    return isNaN(parsed) ? 0 : parsed;
  }

  private formatMoney(amount: number): string {
    return `¥${amount.toFixed(2)}`;
  }

  @Builder
  private buildPriceRow(label: string, value: string, highlight: boolean = false, strong: boolean = false): void {
    Row() {
      Text(label)
        .fontSize(strong ? 16 : $r('app.float.small_font_size'))
        .fontWeight(strong ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(Color.Black)
        .opacity(highlight ? Const.EIGHTY_OPACITY : Const.FULL_OPACITY)

      Blank().layoutWeight(1)

      Text(value)
        .fontSize(strong ? 18 : $r('app.float.small_font_size'))
        .fontWeight(strong ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(highlight ? $r('app.color.focus_color') : Color.Black)
        .textAlign(TextAlign.End)
    }
    .width(Const.FULL_WIDTH)
    .height($r('app.float.piece_line_height'))
  }

  private calcSubtotal(): number {
    return this.items
      .filter((item: CartItem) => this.isSelected(item))
      .reduce((sum: number, item: CartItem) => sum + this.parsePrice(item.price) * item.count, 0);
  }

  private calcDiscount(subtotal: number): number {
    if (!this.appliedCoupon) {
      return 0;
    }
    if (this.appliedCoupon === COUPON_SAVE10) {
      return subtotal * 0.1;
    }
    if (this.appliedCoupon === COUPON_OFF20) {
      return Math.min(subtotal, 20);
    }
    return 0;
  }

  private calcTax(subtotal: number): number {
    return this.taxRate > 0 ? subtotal * this.taxRate : 0;
  }

  private calcServiceFee(subtotal: number): number {
    return subtotal > 0 ? 2 : 0;
  }

  private calcShipping(subtotal: number): number {
    if (subtotal === 0) {
      return 0;
    }
    return subtotal >= 99 ? 0 : 10;
  }

  private getSummary(): CartSummary {
    const subtotal: number = this.calcSubtotal();
    const discount: number = this.calcDiscount(subtotal);
    const serviceFee: number = this.calcServiceFee(subtotal);
    const shipping: number = this.calcShipping(subtotal);
    const tax: number = this.calcTax(subtotal);
    const payable: number = Math.max(0, subtotal - discount + serviceFee + shipping + tax);
    return { subtotal, discount, serviceFee, shipping, tax, payable };
  }

  private selectedItemCount(): number {
    return this.items.filter((item: CartItem) => this.isSelected(item)).length;
  }

  private selectedQuantity(): number {
    return this.items
      .filter((item: CartItem) => this.isSelected(item))
      .reduce((sum: number, item: CartItem) => sum + item.count, 0);
  }

  private onCountChange(item: CartItem, delta: number): void {
    const key: string = this.itemKey(item);

    const idx: number = this.items.findIndex((it: CartItem) => this.itemKey(it) === key);
    if (idx < 0) {
      return;
    }

    const current: number = this.items[idx].count;
    const nextCount: number = current + delta;
    if (nextCount <= 0) {
      return;
    }

    const nextItems: CartItem[] = this.items.map((it: CartItem) => {
      if (this.itemKey(it) !== key) {
        return it;
      }
      const copy: CartItem = this.cloneCartItem(it);
      copy.count = nextCount;
      return copy;
    });

    this.items = nextItems;
    CartStore.updateCount(item.productId, item.skuId, nextCount);
    
    this.recomputeSummary();
    this.updateCouponMessageOnSubtotalChange();
  }

  private onRemove(item: CartItem): void {
    CartStore.remove(item.productId, item.skuId);
    this.refreshItems();
  }

  private removeSelected(): void {
    const targets: CartItem[] = this.items.filter((item: CartItem) => this.isSelected(item));
    targets.forEach((item: CartItem) => {
      CartStore.remove(item.productId, item.skuId);
    });
    this.refreshItems();
  }

  private onApplyCoupon(): void {
    const code: string = this.couponInput.trim().toUpperCase();
    if (!code) {
      this.appliedCoupon = '';
      this.couponMessage = '请输入优惠码';
      return;
    }
    if (code === COUPON_SAVE10 || code === COUPON_OFF20) {
      this.appliedCoupon = code;
      this.couponMessage = code === COUPON_SAVE10 ? '已应用 9 折优惠' : '立减 20 元';
      this.recomputeSummary();
      this.updateCouponMessageOnSubtotalChange();
    } else {
      this.appliedCoupon = '';
      this.couponMessage = '优惠码不可用';
    }
  }

  private updateCouponMessageOnSubtotalChange(): void {
    if (!this.appliedCoupon) {
      return;
    }
    const subtotal: number = this.summary.subtotal;

    if (subtotal <= 0) {
      this.couponMessage = '请先选择商品';
    } else if (this.appliedCoupon === COUPON_SAVE10) {
      this.couponMessage = '已应用 9 折优惠';
    } else if (this.appliedCoupon === COUPON_OFF20) {
      this.couponMessage = subtotal >= 20 ? '已减 20 元' : '已全部抵扣';
    }
  }


  private onCheckout(): void {
    if (this.selectedItemCount() === 0) {
      this.couponMessage = '请选择商品后再结算';
      return;
    }
    try {
      this.getUIContext().getPromptAction().showToast({ message: '已提交结算占位' });
    } catch {
    }
  }

  private onMoveToFavorites(): void {
    try {
      this.getUIContext().getPromptAction().showToast({ message: '已移入收藏（占位）' });
    } catch {
    }
  }

  build() {
    Column() {
      this.buildHeader()

      if (this.items.length === 0) {
        this.buildEmpty()
      } else {
        this.buildContent()    // 不再传 summary
        this.buildFooter()     // 不再传 summary
      }

      this.buildNavBar()
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.home_background_color'))
  }


  @Builder
  private buildHeader(): void {
    Column() {
      Blank()
        .height(this.getUIContext().px2vp(this.topRectHeight))

      Row() {
        Text('<')
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Black)
          .padding({ left: 8, right: 8, top: 8, bottom: 8 })
          .onClick(() => {
            try {
              this.getUIContext().getRouter().back();
            } catch {}
          })

        Text('购物车')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)

        Text(this.editMode ? '完成' : '管理')
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Black)
          .padding({ left: 8, right: 8, top: 8, bottom: 8 })
          .onClick(() => {
            this.editMode = !this.editMode;
          })
      }
      .width(Const.FULL_WIDTH)
      .height(40)
      .padding({
        left: $r('app.float.home_margin_left'),
        right: $r('app.float.home_margin_right'),
        bottom: 6
      })
    }
    .width(Const.FULL_WIDTH)
    .backgroundColor(Color.White)
  }

  @Builder
  private buildContent(): void {
    Scroll() {
      Column() {
        Blank().height(12)

        this.buildSelectAllBar()

        ForEach(this.items, (item: CartItem) => {
          this.buildCartItem(item)
        }, (item: CartItem) => `${this.itemKey(item)}_${item.count}_${this.isSelected(item) ? 1 : 0}`)

        Column() {
          this.buildDiscountCard()
        }
        .margin({ top: 12 })

        Column() {
          this.buildPriceCard()   // 关键：不传 summary
        }
        .margin({ top: 12 })

        Blank().height(12)
      }
      .width(Const.FULL_WIDTH)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: $r('app.float.home_margin_left'),
        right: $r('app.float.home_margin_right'),
        top: 0,
        bottom: 12
      })
    }
    .layoutWeight(1)
    .width(Const.FULL_WIDTH)
  }


  @Builder
  private buildSelectAllBar(): void {
    Row() {
      this.buildCheckbox(
        this.items.length > 0 && this.selectedKeys.length === this.items.length,
        (checked) => this.setSelectAll(checked),
        true
      )

      Text('全选')
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)

      Blank().layoutWeight(1)

      Text(`已选 ${this.selectedQuantity()} 件`)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Gray)
    }
    .width(Const.FULL_WIDTH)
    .height(44)
    .padding({ left: 12, right: 12 })
    .backgroundColor(Color.White)
  }

  @Builder
  private buildCartItem(item: CartItem): void {
    Column() {
      Row({ space: 0 }) {
        this.buildCheckbox(this.isSelected(item),
          (checked) => this.setSelected(this.itemKey(item), checked), true)

        Image(item.image_url)
          .width(76)
          .height(76)
          .borderRadius($r('app.float.product_layout_radius'))
          .objectFit(ImageFit.Contain)
          .backgroundColor(Color.White)
          .margin({ right: 8 })

        Column() {
          Text(item.name)
            .fontSize($r('app.float.small_font_size'))
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(item.skuName)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Gray)
            .opacity(Const.SIXTY_OPACITY)
            .margin({ top: 4 })

          Row() {
            Text(item.price)
              .fontSize($r('app.float.middle_font_size'))
              .fontColor($r('app.color.focus_color'))
              .fontWeight(FontWeight.Bold)

            Blank().layoutWeight(1)

            Text(this.formatMoney(this.parsePrice(item.price) * item.count))
              .fontSize($r('app.float.small_font_size'))
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Medium)
          }
          .width(Const.FULL_WIDTH)
          .margin({ top: 6 })

          Row() {
            this.buildStepper(item)
            Blank().layoutWeight(1)
          }
          .width(Const.FULL_WIDTH)
          .margin({ top: 8 })
        }
        .layoutWeight(1)

        Column() {
          Text('删除')
            .fontSize($r('app.float.smaller_font_size'))
            .padding({ left: 8, right: 8, top: 8, bottom: 8 })
            .onClick(() => this.onRemove(item))
        }
        .alignItems(HorizontalAlign.End)
        .justifyContent(FlexAlign.Start)
      }
      .width(Const.FULL_WIDTH)
      .alignItems(VerticalAlign.Top)
    }
    .width(Const.FULL_WIDTH)
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.product_layout_radius'))
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .margin({ bottom: $r('app.float.water_flow_row_gap') })
  }

  @Builder
  private buildCheckbox(active: boolean, onToggle: (checked: boolean) => void, withRightMargin: boolean = false): void {
    Row() {
      Checkbox()
        .select(active)
        .selectedColor($r('app.color.focus_color'))
        .unselectedColor(Color.White)
        .width(20)
        .height(20)
        .borderRadius(10)
        .onChange((checked) => onToggle(checked))
    }
    .backgroundColor(Color.Transparent)
    .width(36)
    .height(36)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .margin({ right: withRightMargin ? 8 : 0 })
  }

  @Builder
  private buildStepper(item: CartItem): void {
    Row({ space: 0 }) {
      Button('-')
        .width(44)
        .height(44)
        .borderRadius(16)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(item.count <= 1 ? Color.Gray : Color.Black)
        .backgroundColor(Color.White)
        .borderWidth(1)
        .borderColor('#E1E3E6')
        .onClick(() => {
          if (item.count > 1) {
            this.onCountChange(item, -1);
          }
        })
        .padding({ left: 6, right: 6 })

      Text(item.count.toString())
        .width(44)
        .height(44)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)
        .backgroundColor(Color.Transparent)
        .padding({ left: 6, right: 6 })

      Button('+')
        .width(44)
        .height(44)
        .borderRadius(16)
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)
        .backgroundColor(Color.White)
        .borderWidth(1)
        .borderColor('#E1E3E6')
        .onClick(() => this.onCountChange(item, 1))
        .padding({ left: 6, right: 6 })
    }
    .height(44)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private buildDiscountCard(): void {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_search'))
            .width(18)
            .height(18)
            .margin({ right: 8 })

          TextInput({ text: this.couponInput, placeholder: '输入优惠码' })
            .layoutWeight(1)
            .height(40)
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Black)
            .placeholderColor(Color.Gray)
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => this.couponInput = value)
        }
        .height(40)
        .padding({ left: 12, right: 12 })
        .borderRadius(20)
        .backgroundColor(Color.White)

        Button('应用')
          .height(40)
          .fontSize($r('app.float.small_font_size'))
          .borderRadius(20)
          .backgroundColor($r('app.color.focus_color'))
          .fontColor(Color.White)
          .margin({ left: 8 })
          .onClick(() => this.onApplyCoupon())
      }
      .width(Const.FULL_WIDTH)

      if (this.couponMessage) {
        Text(this.couponMessage)
          .fontSize($r('app.float.smaller_font_size'))
          .fontColor(Color.Gray)
          .margin({ top: 8 })
      }
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.product_layout_radius'))
  }

  @Builder
  private buildPriceCard(): void {
    Column() {
      // this.buildPriceRow('商品总价', this.formatMoney(this.summary.subtotal))
      // this.buildPriceRow('折扣优惠', `-${this.formatMoney(this.summary.discount)}`, true)
      // this.buildPriceRow('平台服务费', this.formatMoney(this.summary.serviceFee))
      // this.buildPriceRow('运费', this.summary.shipping === 0 ? '免费' : this.formatMoney(this.summary.shipping), this.summary.shipping === 0)

      if (this.taxRate > 0) {
        this.buildPriceRow('税费', this.formatMoney(this.summary.tax))
      }

      Blank()
        .width(Const.FULL_WIDTH)
        .height(1)
        .backgroundColor('#E8E8E8')
        .margin({ top: 8, bottom: 8 })

      // this.buildPriceRow('应付总计', this.formatMoney(this.summary.payable), false, true)
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.product_layout_radius'))
  }

  @Builder
  private buildFooter(): void {
    // const summary: CartSummary = this.getSummary(); // ✅ 同理：在 Builder 内部建立依赖

    if (this.editMode) {
      Row() {
        this.buildCheckbox(this.items.length > 0 && this.selectedKeys.length === this.items.length,
          (checked) => this.setSelectAll(checked), true)
        Text('全选')
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Black)

        Blank().layoutWeight(1)

        Button('移入收藏')
          .layoutWeight(1)
          .height(44)
          .borderRadius(22)
          .backgroundColor('#F1F3F5')
          .fontColor(Color.Black)
          .onClick(() => this.onMoveToFavorites())

        Button('删除')
          .layoutWeight(1)
          .height(44)
          .margin({ left: 12 })
          .borderRadius(22)
          .backgroundColor($r('app.color.focus_color'))
          .fontColor(Color.White)
          .onClick(() => this.removeSelected())
      }
      .width(Const.FULL_WIDTH)
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .backgroundColor(Color.White)
      .shadow({ radius: 12, color: '#1A000000', offsetX: 0, offsetY: -2 })
    } else {
      Row() {
        Column() {
          Text(`总计`)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Gray)
            .margin({ bottom: 2 })
          Text(this.formatMoney(this.summary.payable))
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
        }
        .padding({ right: 12 })

        Blank().layoutWeight(1)

        Button(this.selectedItemCount() === 0 ? '请选择商品' : '去结算')
          .layoutWeight(1)
          .height(44)
          .borderRadius(22)
          .backgroundColor(this.selectedItemCount() === 0 ? '#F5A0AF' : $r('app.color.focus_color'))
          .fontColor(Color.White)
          .opacity(this.selectedItemCount() === 0 ? Const.SIXTY_OPACITY : Const.FULL_OPACITY)
          .onClick(() => this.onCheckout())
      }
      .width(Const.FULL_WIDTH)
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .backgroundColor(Color.White)
      .shadow({ radius: 12, color: '#1A000000', offsetX: 0, offsetY: -2 })
    }
  }

  @Builder
  private buildEmpty(): void {
    Column() {
      Text('购物车空空如也')
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })
      Text('去逛逛，挑选心仪的商品')
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Gray)
        .margin({ bottom: 12 })
      Button('去首页')
        .height(44)
        .borderRadius(22)
        .backgroundColor($r('app.color.focus_color'))
        .fontColor(Color.White)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          try {
            this.getUIContext().getRouter().replaceUrl({ url: 'pages/HomePage' });
          } catch {
          }
        })
    }
    .width(Const.FULL_WIDTH)
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .padding({
      left: $r('app.float.home_margin_left'),
      right: $r('app.float.home_margin_right')
    })
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
      this.navItem('购物车', true, () => {})
      this.navItem('账户', false, () => {
        try {
          this.getUIContext().getRouter().replaceUrl({ url: 'pages/AccountPage' });
        } catch {
        }
      })
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
