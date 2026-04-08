CLASS lsc_ZCIT_QI_I_22AM022 DEFINITION
  INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_ZCIT_QI_I_22AM022 IMPLEMENTATION.
  METHOD finalize.          ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.
  METHOD cleanup_finalize.  ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcl_qi_util_22am022=>get_instance( ).

    " ── Retrieve from buffer ─────────────────────────────────────
    lo_util->get_hdr_value(  IMPORTING ex_qi_hdr  = DATA(ls_hdr) ).
    lo_util->get_itm_value(  IMPORTING ex_qi_itm  = DATA(ls_itm) ).
    lo_util->get_hdr_deletions( IMPORTING ex_hdr_keys = DATA(lt_hdr_del) ).
    lo_util->get_itm_deletions( IMPORTING ex_itm_keys = DATA(lt_itm_del) ).
    lo_util->get_flags( IMPORTING ex_hdr_del = DATA(lv_hdr_del) ).

    " ── 1. Save / Update Header ──────────────────────────────────
    IF ls_hdr IS NOT INITIAL.
      MODIFY zqi_head_22am022 FROM @ls_hdr.
    ENDIF.

    " ── 2. Save / Update Item ────────────────────────────────────
    IF ls_itm IS NOT INITIAL.
      MODIFY zqi_item_22am022 FROM @ls_itm.
    ENDIF.

    " ── 3. Handle Deletions ──────────────────────────────────────
    IF lv_hdr_del = abap_true.
      " Cascade delete: remove header AND all related items
      LOOP AT lt_hdr_del INTO DATA(ls_del_hdr).
        DELETE FROM zqi_head_22am022
          WHERE inspectionlot = @ls_del_hdr-inspectionlot.
        DELETE FROM zqi_item_22am022
          WHERE inspectionlot = @ls_del_hdr-inspectionlot.
      ENDLOOP.
    ELSE.
      " Delete individual headers
      LOOP AT lt_hdr_del INTO ls_del_hdr.
        DELETE FROM zqi_head_22am022
          WHERE inspectionlot = @ls_del_hdr-inspectionlot.
      ENDLOOP.
      " Delete individual items
      LOOP AT lt_itm_del INTO DATA(ls_del_itm).
        DELETE FROM zqi_item_22am022
          WHERE inspectionlot = @ls_del_itm-inspectionlot
          AND   itemno        = @ls_del_itm-itemno.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcl_qi_util_22am022=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.
 ENDCLASS.
