@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View - QI Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZCIT_QI_O_22AM022
  as select from zqi_item_22am022
  association to parent ZCIT_QI_I_22AM022 as _qiheader
    on $projection.InspectionLot = _qiheader.InspectionLot
{
  key inspectionlot   as InspectionLot,
  key itemno          as Itemno,
  characteristic      as Characteristic,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  minvalue            as Minvalue,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  maxvalue            as Maxvalue,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  actualvalue         as Actualvalue,
  uom                 as Uom,
  results              as Results,
  @Semantics.user.createdBy: true
  local_created_by    as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at    as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by  as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at  as LocalLastChangedAt,
 
  /* Associations */
  _qiheader
}
