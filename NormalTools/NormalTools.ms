fileIn "NormalTools.functions.ms"
    
fn NormalToolsPreCheck = 
(
    if (Selection.count != 1) then
    (
        Messagebox "Please select ONE and ONLY ONE object."
    )
    else 
    if (NormalTools.IsEditable $ == false) then
    (
        Messagebox "Selection is not a Editable_Poly object."
    )
    else
    (
        return NormalTools.ValidNormalModifier $
    )
    
    return undefined
)
    
rollout NormalTools_OffsetRollout "Nomral Offset"
(
    label        lbl_Mode              "Mode "           pos:[16,12]   width:40  height:16
    radioButtons rdo_Mode              ""                pos:[56,12]   width:138 height:16 labels:#("Add", "Multiply") columns:2

    label        lbl_NormalX           "X"               pos:[16,39]   width:16  height:16
    spinner      spn_NormalOffsetX     ""                pos:[32,39]   width:152 height:16 range:[-100.0,100.0,0.0]
    button       btn_AddSmallOffsetX   "+0.1"            pos:[192,36]  width:36  height:24
    button       btn_AddOffsetX        "+0.5"            pos:[237,36]  width:36  height:24
    button       btn_MinusOffsetX      "-0.5"            pos:[282,36]  width:36  height:24
    button       btn_MinusSmallOffsetX "-0.1"            pos:[327,36]  width:36  height:24

    label        lbl_NormalZ           "Z"               pos:[17,105]  width:15  height:16
    spinner      spn_NormalOffsetZ     ""                pos:[32,104]  width:152 height:16 range:[-100.0,100.0,1.0]
    button       btn_AddSmallOffsetZ   "+0.1"            pos:[193,102] width:36  height:24
    button       btn_AddOffsetZ        "+0.5"            pos:[237,102] width:36  height:24
    button       btn_MinusOffsetZ      "-0.5"            pos:[282,102] width:36  height:24
    button       btn_MinusSmallOffsetZ "-0.1"            pos:[327,102] width:36  height:24

    label        lbl_NormalY           "Y"               pos:[17,73]   width:16  height:16
    spinner      spn_NormalOffsetY     ""                pos:[32,72]   width:152 height:16 range:[-100.0,100.0,0.0]
    button       btn_AddSmallOffsetY   "+0.1"            pos:[193,70]  width:36  height:24
    button       btn_AddOffsetY        "+0.5"            pos:[237,70]  width:36  height:24
    button       btn_MinusOffsetY      "-0.5"            pos:[282,70]  width:36  height:24
    button       btn_MinusSmallOffsetY "-0.1"            pos:[327,70]  width:36  height:24
    
    checkbox     chk_AbsValue          "Absolute Value"  pos:[188,139] width:98  height:16 checked:true
    checkbox     chk_WorldSpace        "World Space"     pos:[285,139] width:98  height:16
    button       btn_ResetOffset       "Reset"           pos:[17,134]  width:78  height:24
    button       btn_Apply             "Apply"           pos:[102,134] width:78  height:24

    fn ApplyOffset =
    (
        local editor = NormalToolsPreCheck()
        if  editor != undefined then
        (
            local v = [spn_NormalOffsetX.Value, spn_NormalOffsetY.Value, spn_NormalOffsetZ.Value]

            if rdo_Mode.state == 1 then
            (
                NormalTools.AddNormalOffset $ v editor chk_AbsValue.checked chk_WorldSpace.checked
            )
            else
            (
                NormalTools.MulNormalOffset $ v editor chk_WorldSpace.checked
            )
        )
    )

    on btn_AddSmallOffsetX pressed   do  ( spn_NormalOffsetX.Value =  0.1; ApplyOffset() )
    on btn_AddOffsetX pressed        do  ( spn_NormalOffsetX.Value =  0.5; ApplyOffset() )
    on btn_MinusOffsetX pressed      do  ( spn_NormalOffsetX.Value = -0.5; ApplyOffset() )
    on btn_MinusSmallOffsetX pressed do  ( spn_NormalOffsetX.Value = -0.1; ApplyOffset() )
    on btn_AddSmallOffsetZ pressed   do  ( spn_NormalOffsetZ.Value =  0.1; ApplyOffset() )
    on btn_AddOffsetZ pressed        do  ( spn_NormalOffsetZ.Value =  0.5; ApplyOffset() )
    on btn_MinusOffsetZ pressed      do  ( spn_NormalOffsetZ.Value = -0.5; ApplyOffset() )
    on btn_MinusSmallOffsetZ pressed do  ( spn_NormalOffsetZ.Value = -0.1; ApplyOffset() )
    on btn_AddSmallOffsetY pressed   do  ( spn_NormalOffsetY.Value =  0.1; ApplyOffset() )
    on btn_AddOffsetY pressed        do  ( spn_NormalOffsetY.Value =  0.5; ApplyOffset() )
    on btn_MinusOffsetY pressed      do  ( spn_NormalOffsetY.Value = -0.5; ApplyOffset() )
    on btn_MinusSmallOffsetY pressed do  ( spn_NormalOffsetY.Value = -0.1; ApplyOffset() )
    on btn_ResetOffset pressed       do  ( spn_NormalOffsetX.Value = spn_NormalOffsetY.Value = spn_NormalOffsetZ.Value = if rdo_Mode.state == 1 then 0 else 1 )
    
    on btn_Apply pressed do
    (
        ApplyOffset()
    )

    on NormalTools_OffsetRollout open do
    (
        
    )
)

rollout NormalTools_NormalEditRollout "Nomral Edit" width:376 height:544
(
    button       btn_Clr2Nrm           "Color to Normal" pos:[16,12]   width:168 height:32
    button       btn_Nrm2Clr           "Normal to Color" pos:[192,12]  width:168 height:32

    button       btn_StealNormal       "Normal Thief"    pos:[16,132]  width:88  height:32
    pickbutton   btn_PickSource        "Pick Source"     pos:[112,132] width:250 height:32
        
    button       btn_Normalize         "Normalize"       pos:[16,52]   width:168 height:32
    button       brn_InverseNormal     "Inverse"         pos:[192,52]  width:168 height:32
    button       btn_Smooth            "Smooth"          pos:[16,92]   width:168 height:32
    button       btn_RemakeNormal      "Remake"          pos:[192,92]  width:168 height:32
    
    on btn_Clr2Nrm pressed  do
    (
        Messagebox "TODO"
    )

    on btn_Nrm2Clr pressed  do
    (
        local editor = NormalToolsPreCheck()
        if  editor != undefined then
        (
            NormalTools.CovertNormalToVertexColor $ editor
        )
    )

    on btn_StealNormal pressed  do
    (
        local editor = NormalToolsPreCheck()
        if (isValidObj NormalTools.NormalTransferSource) and editor != undefined then
        (
            NormalTools.TransferNormal $ NormalTools.NormalTransferSource editor
        )
        else
        (
            if isValidObj NormalTools.NormalTransferSource == false then btn_PickSource.text = "Pick Source"
        )
    )

    on btn_PickSource picked target  do
    (
        if (target != undefined) do 
        (
            if (target == $) then
            (
                return()
            )

            btn_PickSource.text = ("FROM - " + target.name)
            NormalTools.NormalTransferSource = target
        )
    )

    on btn_Normalize pressed  do
    (
        local editor = NormalToolsPreCheck()
        if  editor != undefined then
        (
            NormalTools.NormalizeNormal $ editor
        )
    )
    on brn_InverseNormal pressed  do
    (
        local editor = NormalToolsPreCheck()
        if  editor != undefined then
        (
            NormalTools.InverseNormal $ editor
        )
    )
    on btn_RemakeNormal pressed  do
    (
        local editor = NormalToolsPreCheck()
        if  editor != undefined then
        (
            NormalTools.RemakeNormals $ editor
        )
    )
    on btn_Smooth pressed  do
    (
        Messagebox "TODO"
    )
    
    on NormalTools_NormalEditRollout open do
    (

    )
)

rollout NormalTools_SpherizeRollout "Normal Spherize" width:376 height:544
(
    label        lbl_SpherizeRaito    "Ratio"            pos:[16,12]  width:48  height:16
    spinner      spn_SpherizeRaito     ""                pos:[48,12]  width:135 height:16 range:[0.0,1.0,0.0]
    button       btn_TinyRatio         "0.1"             pos:[192,8]  width:36  height:24
    button       btn_SmallRatio        "0.25"            pos:[237,8]  width:36  height:24
    button       btn_HalfRatio         "0.5"             pos:[282,8]  width:36  height:24
    button       btn_LargeRatio        "0.70"            pos:[327,8]  width:36  height:24
    
    pickbutton   btn_CreateCenter      "Create Center"   pos:[16,36]  width:168 height:32
    button       btn_ApplySpherize     "Apply"           pos:[192,36] width:168 height:32

    fn SpherizeNormal = 
    (
        if NormalTools.SpherizeCenter != undefined and isValidObj NormalTools.SpherizeCenter == false then
        (
            NormalTools.SpherizeCenter = undefined
            btn_CreateCenter.text = "Create Center"
        )

        local editor = NormalToolsPreCheck()
        if  editor != undefined then
        (
            NormalTools.SpherizeNormal $ editor spn_SpherizeRaito.Value
        )
    )

    on btn_TinyRatio pressed  do ( spn_SpherizeRaito.Value = 0.1;  SpherizeNormal() )
    on btn_SmallRatio pressed do ( spn_SpherizeRaito.Value = 0.25; SpherizeNormal() )
    on btn_HalfRatio pressed  do ( spn_SpherizeRaito.Value = 0.5;  SpherizeNormal() )
    on btn_LargeRatio pressed do ( spn_SpherizeRaito.Value = 0.7;  SpherizeNormal() )

    on btn_CreateCenter picked target  do
    (
        if (target == NormalTools.SpherizeCenter) then
        (
            NormalTools.SpherizeCenter = undefined
            btn_CreateCenter.text = "Create Center"
        )
        else
        if (target != undefined) then
        (
            NormalTools.SpherizeCenter = target
            btn_CreateCenter.text = target.name
        )
    )

    on btn_ApplySpherize pressed  do
    (
        SpherizeNormal()
    )
    
    on NormalTools_SpherizeRollout open do
    (

    )
)


if NormalToolsPreCheck() != undefined then
(
    if nmt_floater != undefined then CloseRolloutFloater nmt_floater

    NormalTools.Init()
        
    nmt_floater = newRolloutFloater ("NormalTools v1.01 - " + $.name) 382 485
    addRollout NormalTools_OffsetRollout nmt_floater
    addRollout NormalTools_SpherizeRollout nmt_floater
    addRollout NormalTools_NormalEditRollout nmt_floater
)
