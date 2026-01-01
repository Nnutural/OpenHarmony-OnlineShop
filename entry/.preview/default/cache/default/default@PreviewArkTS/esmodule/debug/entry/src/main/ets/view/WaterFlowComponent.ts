if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface WaterFlowComponent_Params {
    bottomRectHeight?: number;
    datasource?: WaterFlowDataSource;
    sections?: WaterFlowSections;
}
import type ProductItem from '../viewmodel/ProductItem';
import { WaterFlowDataSource } from "@bundle:com.huawei.waterflow/entry/ets/viewmodel/WaterFlowDataSource";
import { CommonConstants as Const } from "@bundle:com.huawei.waterflow/entry/ets/common/constants/CommonConstants";
import { waterFlowData } from "@bundle:com.huawei.waterflow/entry/ets/viewmodel/HomeViewModel";
import FlowItemComponent from "@bundle:com.huawei.waterflow/entry/ets/view/FlowItemComponent";
export default class WaterFlowComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__bottomRectHeight = this.createStorageLink('bottomRectHeight', 0, "bottomRectHeight");
        this.datasource = new WaterFlowDataSource();
        this.sections = new WaterFlowSections();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: WaterFlowComponent_Params) {
        if (params.datasource !== undefined) {
            this.datasource = params.datasource;
        }
        if (params.sections !== undefined) {
            this.sections = params.sections;
        }
    }
    updateStateVars(params: WaterFlowComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__bottomRectHeight.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__bottomRectHeight.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __bottomRectHeight: ObservedPropertyAbstractPU<number>;
    get bottomRectHeight() {
        return this.__bottomRectHeight.get();
    }
    set bottomRectHeight(newValue: number) {
        this.__bottomRectHeight.set(newValue);
    }
    private datasource: WaterFlowDataSource;
    private sections: WaterFlowSections;
    aboutToAppear() {
        this.datasource.setDataArray(waterFlowData);
        this.buildSections();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            WaterFlow.create({ footer: (): void => this.itemFoot(), sections: this.sections });
            WaterFlow.debugLine("entry/src/main/ets/view/WaterFlowComponent.ets(39:5)", "entry");
            WaterFlow.layoutWeight(Const.WATER_FLOW_LAYOUT_WEIGHT);
            WaterFlow.layoutDirection(FlexDirection.Column);
            WaterFlow.columnsTemplate(Const.WATER_FLOW_COLUMNS_TEMPLATE);
            WaterFlow.columnsGap({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
            WaterFlow.rowsGap({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
        }, WaterFlow);
        {
            const __lazyForEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    FlowItem.create();
                    FlowItem.debugLine("entry/src/main/ets/view/WaterFlowComponent.ets(41:9)", "entry");
                }, FlowItem);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new FlowItemComponent(this, {
                                item: item,
                                onItemClick: (product: ProductItem) => {
                                    if (product.id === 'banner') {
                                        return;
                                    }
                                    this.getUIContext().getRouter().pushUrl({
                                        url: 'pages/ProductDetailPage',
                                        params: {
                                            productId: product.id,
                                            from: 'home'
                                        }
                                    });
                                }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/WaterFlowComponent.ets", line: 42, col: 11 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    item: item,
                                    onItemClick: (product: ProductItem) => {
                                        if (product.id === 'banner') {
                                            return;
                                        }
                                        this.getUIContext().getRouter().pushUrl({
                                            url: 'pages/ProductDetailPage',
                                            params: {
                                                productId: product.id,
                                                from: 'home'
                                            }
                                        });
                                    }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "FlowItemComponent" });
                }
                FlowItem.pop();
            };
            const __lazyForEachItemIdFunc = (item: ProductItem) => item.id;
            LazyForEach.create("1", this, this.datasource, __lazyForEachItemGenFunction, __lazyForEachItemIdFunc);
            LazyForEach.pop();
        }
        WaterFlow.pop();
    }
    itemFoot(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/view/WaterFlowComponent.ets(70:5)", "entry");
            Column.margin({
                top: { "id": 16777294, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                bottom: this.getUIContext().px2vp(this.bottomRectHeight)
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777220, "type": 10003, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/view/WaterFlowComponent.ets(71:7)", "entry");
            Text.fontColor(Color.Gray);
            Text.fontSize({ "id": 16777254, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
            Text.width(Const.FULL_WIDTH);
            Text.height({ "id": 16777253, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
            Text.textAlign(TextAlign.Center);
        }, Text);
        Text.pop();
        Column.pop();
    }
    private buildSections(): void {
        this.sections = new WaterFlowSections();
        const total: number = this.datasource.totalCount();
        if (total <= 0) {
            return;
        }
        // First item (banner) spans full width with single column, add bottom margin to avoid overlap.
        this.sections.push({
            itemsCount: 1,
            crossCount: 1,
            margin: { bottom: { "id": 16777299, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" } }
        });
        if (total > 1) {
            this.sections.push({
                itemsCount: total - 1,
                crossCount: 2
            });
        }
    }
    rerender() {
        this.updateDirtyElements();
    }
}
