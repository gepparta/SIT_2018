*&---------------------------------------------------------------------*
*& Report z_age_demo_sit_2018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_age_demo_sit_2018.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
  PRIVATE SECTION.


    CLASS-METHODS:
      request_infos_4_trips
        CHANGING
          airline_code   TYPE s_carr_id
          flight_no      TYPE s_conn_id
          airline_code_2 TYPE s_carr_id
          flight_no_2    TYPE s_conn_id,
      trip_data
        IMPORTING
                  i_airline_code     TYPE s_carr_id
                  i_flight_no        TYPE s_conn_id
        RETURNING VALUE(r_trip_data) TYPE zts_trip_type.
ENDCLASS.


CLASS demo IMPLEMENTATION.
  METHOD request_infos_4_trips.
    cl_demo_input=>new(
      )->add_field( EXPORTING text = |1# Airline Code|  CHANGING field = airline_code
      )->add_field( EXPORTING text = |1# Flight number| CHANGING field = flight_no
      )->add_field( EXPORTING text = |2# Airline Code|  CHANGING field = airline_code_2
      )->add_field( EXPORTING text = |2# Flight number| CHANGING field = flight_no_2
      )->request(  ).
  ENDMETHOD.

  METHOD trip_data.
    SELECT SINGLE carrid, connid, distance, distid
      INTO @r_trip_data
        FROM spfli
             WHERE carrid EQ @i_airline_code AND
                   connid EQ @i_flight_no.
  ENDMETHOD.


  METHOD main.
    DATA:
      airline_code   TYPE s_carr_id  VALUE 'JL', "Airline Code
      flight_no      TYPE s_conn_id  VALUE '0408', "Flight number
      airline_code_2 TYPE s_carr_id  VALUE 'AZ', "Airline Code
      flight_no_2    TYPE s_conn_id  VALUE '0789', "Flight number
      trips          TYPE ztt_trip_type.

    request_infos_4_trips(
          CHANGING
            airline_code      = airline_code
            flight_no         = flight_no
            airline_code_2    = airline_code_2
            flight_no_2       = flight_no_2 ).

    APPEND  trip_data( i_airline_code = airline_code
                       i_flight_no    = flight_no ) TO trips.

    APPEND  trip_data( i_airline_code = airline_code_2
                       i_flight_no    = flight_no_2 ) TO trips.


    DATA(distance_calculator) = NEW zcl_age_distance_calculator( trips ).

    cl_demo_output=>new( )->display( distance_calculator->distance_sum( ) ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).
