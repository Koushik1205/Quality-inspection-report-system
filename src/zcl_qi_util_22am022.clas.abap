CLASS zcl_qi_util_22am022 DEFINITION
  PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_qi_hdr_key,
             inspectionlot TYPE ZCIT_DOM_22AM022,
           END OF ty_qi_hdr_key,
           BEGIN OF ty_qi_itm_key,
             inspectionlot TYPE ZCIT_DOM_22AM022,
             itemno        TYPE int2,
           END OF ty_qi_itm_key.
    TYPES: tt_qi_hdr_keys TYPE STANDARD TABLE OF ty_qi_hdr_key,
           tt_qi_itm_keys TYPE STANDARD TABLE OF ty_qi_itm_key.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_qi_util_22am022.

    METHODS:
      set_hdr_value
        IMPORTING im_qi_hdr  TYPE zqi_head_22am022
        EXPORTING ex_created TYPE abap_boolean,
      get_hdr_value
        EXPORTING ex_qi_hdr  TYPE zqi_head_22am022,
      set_itm_value
        IMPORTING im_qi_itm  TYPE zqi_item_22am022
        EXPORTING ex_created TYPE abap_boolean,
      get_itm_value
        EXPORTING ex_qi_itm  TYPE zqi_item_22am022,
      set_hdr_deletion
        IMPORTING im_hdr_key TYPE ty_qi_hdr_key,
      set_itm_deletion
        IMPORTING im_itm_key TYPE ty_qi_itm_key,
      get_hdr_deletions
        EXPORTING ex_hdr_keys TYPE tt_qi_hdr_keys,
      get_itm_deletions
        EXPORTING ex_itm_keys TYPE tt_qi_itm_keys,
      set_hdr_delete_flag
        IMPORTING im_flag TYPE abap_boolean,
      get_flags
        EXPORTING ex_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: gs_qi_hdr_buff    TYPE zqi_head_22am022,
                gs_qi_itm_buff    TYPE zqi_item_22am022,
                gt_hdr_del_keys   TYPE tt_qi_hdr_keys,
                gt_itm_del_keys   TYPE tt_qi_itm_keys,
                gv_hdr_del_flag   TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcl_qi_util_22am022.
ENDCLASS.

CLASS zcl_qi_util_22am022 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_qi_hdr-inspectionlot IS NOT INITIAL.
      gs_qi_hdr_buff = im_qi_hdr.
      ex_created     = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_qi_hdr = gs_qi_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    IF im_qi_itm IS NOT INITIAL.
      gs_qi_itm_buff = im_qi_itm.
      ex_created     = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_qi_itm = gs_qi_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_deletion.
    APPEND im_hdr_key TO gt_hdr_del_keys.
  ENDMETHOD.

  METHOD set_itm_deletion.
    APPEND im_itm_key TO gt_itm_del_keys.
  ENDMETHOD.

  METHOD get_hdr_deletions.
    ex_hdr_keys = gt_hdr_del_keys.
  ENDMETHOD.

  METHOD get_itm_deletions.
    ex_itm_keys = gt_itm_del_keys.
  ENDMETHOD.

  METHOD set_hdr_delete_flag.
    gv_hdr_del_flag = im_flag.
  ENDMETHOD.

  METHOD get_flags.
    ex_hdr_del = gv_hdr_del_flag.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_qi_hdr_buff, gs_qi_itm_buff,
           gt_hdr_del_keys, gt_itm_del_keys, gv_hdr_del_flag.
  ENDMETHOD.
ENDCLASS.

