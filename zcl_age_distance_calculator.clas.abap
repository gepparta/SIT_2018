CLASS zcl_age_distance_calculator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          i_trips TYPE ztt_trip_type,
      distance_sum
        RETURNING VALUE(r_distance_sum) TYPE zts_distance_type.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: m_trips TYPE ztt_trip_type.
ENDCLASS.



CLASS zcl_age_distance_calculator IMPLEMENTATION.
  METHOD constructor.
    m_trips = i_trips.
  ENDMETHOD.

  METHOD distance_sum.
    LOOP AT m_trips ASSIGNING FIELD-SYMBOL(<trip>).
      r_distance_sum-distance = r_distance_sum-distance + <trip>-distance.
    ENDLOOP.
    "maybe we need to consider units here later?
    "for now we always use KM
    r_distance_sum-distid = 'KM'.
  ENDMETHOD.
ENDCLASS.
