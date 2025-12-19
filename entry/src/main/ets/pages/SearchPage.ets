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
import FlowItemComponent from '../view/FlowItemComponent';
import ProductItem from '../viewmodel/ProductItem';
import { getHotSearchKeywords, searchProducts } from '../services/product.service';

const SEARCH_HISTORY_KEY: string = 'search_history';
const SEARCH_QUERY_KEY: string = 'search_query';
const SEARCH_SCROLL_OFFSET_KEY: string = 'search_scroll_offset';

PersistentStorage.persistProp(SEARCH_HISTORY_KEY, [] as string[]);
AppStorage.setOrCreate(SEARCH_QUERY_KEY, '');
AppStorage.setOrCreate(SEARCH_SCROLL_OFFSET_KEY, 0);

@Entry
@Component
struct SearchPage {
  @StorageLink('search_query') private query: string = '';
  @StorageLink('search_history') private history: string[] = [];
  @StorageLink(SEARCH_SCROLL_OFFSET_KEY) private scrollOffset: number = 0;
  @State private hotKeywords: string[] = [];
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';
  @State private results: ProductItem[] = [];
  @State private lastSearchedQuery: string = '';

  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0;

  private debounceTimer: number = -1;
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.hotKeywords = getHotSearchKeywords();
    const keyword: string = this.query.trim();
    if (!keyword) {
      this.results = [];
      return;
    }
    if (this.lastSearchedQuery !== keyword) {
      this.triggerSearch(false);
    }
  }

  aboutToDisappear(): void {
    if (this.debounceTimer >= 0) {
      clearTimeout(this.debounceTimer);
      this.debounceTimer = -1;
    }
  }

  private onQueryChange(value: string): void {
    this.query = value;
    this.errorMessage = '';

    if (this.debounceTimer >= 0) {
      clearTimeout(this.debounceTimer);
    }
    this.debounceTimer = setTimeout(() => {
      this.triggerSearch(false);
    }, 300);
  }

  private onSubmit(): void {
    this.triggerSearch(true);
  }

  private addToHistory(keyword: string): void {
    const normalized: string = keyword.trim();
    if (!normalized) {
      return;
    }
    const current: string[] = this.history ?? [];
    const next: string[] = [normalized, ...current.filter((item: string) => item !== normalized)].slice(0, 20);
    AppStorage.set(SEARCH_HISTORY_KEY, next);
  }

  private clearHistory(): void {
    AppStorage.set(SEARCH_HISTORY_KEY, []);
  }

  private useKeyword(keyword: string): void {
    this.query = keyword;
    this.triggerSearch(true);
  }

  private clearQuery(): void {
    this.query = '';
    this.errorMessage = '';
    this.isLoading = false;
    this.results = [];
    this.lastSearchedQuery = '';
    this.scrollOffset = 0;
  }

  private async triggerSearch(saveHistory: boolean): Promise<void> {
    const keyword: string = this.query.trim();
    if (!keyword) {
      this.results = [];
      return;
    }

    if (saveHistory) {
      this.addToHistory(keyword);
    }

    this.lastSearchedQuery = keyword;
    this.isLoading = true;
    this.errorMessage = '';
    this.scrollOffset = 0;
    try {
      this.results = await searchProducts(keyword);
    } catch (err) {
      this.errorMessage = err instanceof Error ? err.message : '搜索失败，请重试';
      this.results = [];
    } finally {
      this.isLoading = false;
    }
  }

  private goDetail(product: ProductItem): void {
    try {
      this.getUIContext().getRouter().pushUrl({
        url: 'pages/ProductDetailPage',
        params: {
          productId: product.id,
          from: 'search'
        }
      });
    } catch {
    }
  }

  build() {
    Column() {
      this.buildSearchBar()

      if (this.query.trim().length === 0) {
        this.buildSuggestions()
      } else {
        this.buildResults()
      }
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.home_background_color'))
  }

  @Builder
  private buildSearchBar() {
    Row() {
      Text('返回')
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)
        .padding({ left: 8, right: 8, top: 8, bottom: 8 })
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })

      Row() {
        Image($r('app.media.ic_search'))
          .width(18)
          .height(18)
          .margin({ left: 10, right: 6 })

        TextInput({ text: this.query, placeholder: '搜索商品' })
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Black)
          .placeholderColor(Color.Gray)
          .onChange((value: string) => this.onQueryChange(value))
          .onSubmit(() => this.onSubmit())

        if (this.query.length > 0) {
          Text('×')
            .fontSize(18)
            .fontColor(Color.Gray)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .onClick(() => this.clearQuery())
        }
      }
      .layoutWeight(1)
      .height(40)
      .borderRadius(20)
      .backgroundColor(Color.White)
    }
    .width(Const.FULL_WIDTH)
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
  }

  @Builder
  private buildSuggestions() {
    Scroll() {
      Column() {
        if (this.history.length > 0) {
          Row() {
            Text('搜索历史')
              .fontSize(16)
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Medium)
            Blank().layoutWeight(1)
            Text('清空')
              .fontSize($r('app.float.small_font_size'))
              .fontColor(Color.Gray)
              .onClick(() => this.clearHistory())
          }
          .margin({ bottom: 12 })

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.history, (item: string, index: number) => {
              Text(item)
                .fontSize($r('app.float.small_font_size'))
                .fontColor(Color.Black)
                .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                .backgroundColor(Color.White)
                .borderRadius(16)
                .margin({ right: 8, bottom: 8 })
                .onClick(() => this.useKeyword(item))
            }, (item: string, index: number) => `${item}_${index}`)
          }
          .width(Const.FULL_WIDTH)
          .margin({ bottom: 16 })
        }

        Text('热门搜索')
          .fontSize(16)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.hotKeywords, (item: string, index: number) => {
            Text(item)
              .fontSize($r('app.float.small_font_size'))
              .fontColor($r('app.color.focus_color'))
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .backgroundColor('#FCE4EA')
              .borderRadius(16)
              .margin({ right: 8, bottom: 8 })
              .onClick(() => this.useKeyword(item))
          }, (item: string, index: number) => `${item}_${index}`)
        }
        .width(Const.FULL_WIDTH)

        Blank()
          .height(this.getUIContext().px2vp(this.bottomRectHeight))
      }
      .padding(12)
    }
    .layoutWeight(1)
    .width(Const.FULL_WIDTH)
  }

  @Builder
  private buildResults() {
    Column() {
      if (this.isLoading) {
        Column() {
          Text('搜索中...')
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Gray)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .width(Const.FULL_WIDTH)
      } else if (this.errorMessage) {
        Column() {
          Text(this.errorMessage)
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Gray)
            .margin({ bottom: 12 })
          Button('重试')
            .onClick(() => this.triggerSearch(false))
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .width(Const.FULL_WIDTH)
      } else if (this.results.length === 0) {
        Column() {
          Text('无结果')
            .fontSize(16)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
          Text('换个关键词试试，或清空筛选')
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Gray)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .width(Const.FULL_WIDTH)
      } else {
        WaterFlow({ scroller: this.scroller }) {
          ForEach(this.results, (item: ProductItem) => {
            FlowItem() {
              FlowItemComponent({
                item: item,
                onItemClick: (product: ProductItem) => this.goDetail(product)
              })
            }
          }, (item: ProductItem) => item.id)
        }
        .onAppear(() => {
          if (this.scrollOffset > 0) {
            this.scroller.scrollTo({ xOffset: 0, yOffset: this.scrollOffset, animation: false });
          }
        })
        .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
          this.scrollOffset = scrollOffset;
        })
        .layoutWeight(1)
        .layoutDirection(FlexDirection.Column)
        .columnsTemplate(Const.WATER_FLOW_COLUMNS_TEMPLATE)
        .columnsGap($r('app.float.water_flow_columns_gap'))
        .rowsGap($r('app.float.water_flow_row_gap'))
        .padding({ left: 12, right: 12, top: 12 })
      }
    }
    .layoutWeight(1)
    .width(Const.FULL_WIDTH)
  }
}
