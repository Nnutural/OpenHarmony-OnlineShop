if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface FlowItemComponent_Params {
    item?: ProductItem;
    onItemClick?: (item: ProductItem) => void;
}
import { CommonConstants as Const } from "@bundle:com.huawei.waterflow/entry/ets/common/constants/CommonConstants";
import type ProductItem from '../viewmodel/ProductItem';
import { waterFlowData } from "@bundle:com.huawei.waterflow/entry/ets/viewmodel/HomeViewModel";
import SwiperComponent from "@bundle:com.huawei.waterflow/entry/ets/view/SwiperComponent";
export default class FlowItemComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.item = waterFlowData[0];
        this.onItemClick = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: FlowItemComponent_Params) {
        if (params.item !== undefined) {
            this.item = params.item;
        }
        if (params.onItemClick !== undefined) {
            this.onItemClick = params.onItemClick;
        }
    }
    updateStateVars(params: FlowItemComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private item: ProductItem;
    private onItemClick?: (item: ProductItem) => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.item.id === 'banner') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(32:7)", "entry");
                        Column.width(Const.FULL_WIDTH);
                        Column.backgroundColor(Color.Transparent);
                        Column.onClick(() => {
                            // banner 不跳转
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        __Common__.create();
                        __Common__.width(Const.FULL_WIDTH);
                        __Common__.height({ "id": 16777287, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                    }, __Common__);
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new SwiperComponent(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/FlowItemComponent.ets", line: 33, col: 9 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {};
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "SwiperComponent" });
                    }
                    __Common__.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(43:7)", "entry");
                        Column.borderRadius({ "id": 16777268, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Column.backgroundColor(Color.White);
                        Column.width(Const.FULL_WIDTH);
                        Column.height({ "id": 16777301, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Column.onClick(() => {
                            this.onItemClick?.(this.item);
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(44:9)", "entry");
                        Column.width(Const.FULL_WIDTH);
                        Column.height({ "id": 16777302, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Column.backgroundColor('#FAFBFD');
                        Column.borderRadius({ topLeft: { "id": 16777268, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }, topRight: { "id": 16777268, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }, bottomLeft: 0, bottomRight: 0 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create(this.item?.image_url);
                        Image.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(45:11)", "entry");
                        Image.width(Const.FULL_WIDTH);
                        Image.height({ "id": 16777302, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Image.objectFit(ImageFit.Contain);
                        Image.margin({
                            top: { "id": 16777293, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                            bottom: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
                        });
                    }, Image);
                    Column.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(59:9)", "entry");
                        Column.width(Const.FULL_WIDTH);
                        Column.layoutWeight(1);
                        Column.backgroundColor(Color.White);
                        Column.padding({
                            left: { "id": 16777266, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                            right: { "id": 16777267, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                            bottom: { "id": 16777265, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                            top: { "id": 16777265, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.item?.name);
                        Text.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(60:11)", "entry");
                        Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Text.fontColor(Color.Black);
                        Text.fontWeight(FontWeight.Bold);
                        Text.alignSelf(ItemAlign.Start);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.item?.discount);
                        Text.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(65:11)", "entry");
                        Text.fontSize({ "id": 16777284, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Text.fontColor(Color.Black);
                        Text.fontWeight(FontWeight.Medium);
                        Text.opacity(Const.SIXTY_OPACITY);
                        Text.alignSelf(ItemAlign.Start);
                        Text.margin({
                            bottom: { "id": 16777252, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
                        });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.item?.price);
                        Text.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(74:11)", "entry");
                        Text.fontSize({ "id": 16777258, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Text.fontColor({ "id": 16777240, "type": 10001, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                        Text.fontWeight(FontWeight.Bold);
                        Text.alignSelf(ItemAlign.Start);
                        Text.lineHeight({ "id": 16777263, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(80:11)", "entry");
                        Row.width(Const.FULL_WIDTH);
                        Row.justifyContent(FlexAlign.Start);
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.item?.promotion) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Text.create(`${this.item?.promotion}`);
                                    Text.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(82:15)", "entry");
                                    Text.height({ "id": 16777275, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.fontSize({ "id": 16777269, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.fontColor(Color.White);
                                    Text.borderRadius({ "id": 16777274, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.backgroundColor({ "id": 16777240, "type": 10001, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.padding({
                                        left: { "id": 16777272, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                                        right: { "id": 16777273, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
                                    });
                                    Text.margin({
                                        top: { "id": 16777271, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                                        right: { "id": 16777270, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
                                    });
                                }, Text);
                                Text.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.item?.bonus_points) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Text.create(`${this.item?.bonus_points}`);
                                    Text.debugLine("entry/src/main/ets/view/FlowItemComponent.ets(98:15)", "entry");
                                    Text.height({ "id": 16777275, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.fontSize({ "id": 16777269, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.fontColor({ "id": 16777240, "type": 10001, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.borderRadius({ "id": 16777274, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.borderWidth({ "id": 16777250, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.borderColor({ "id": 16777240, "type": 10001, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" });
                                    Text.padding({
                                        left: { "id": 16777248, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" },
                                        right: { "id": 16777249, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" }
                                    });
                                    Text.margin({ top: { "id": 16777247, "type": 10002, params: [], "bundleName": "com.huawei.waterflow", "moduleName": "entry" } });
                                }, Text);
                                Text.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                    Row.pop();
                    Column.pop();
                    Column.pop();
                });
            }
        }, If);
        If.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
