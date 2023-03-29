select
    contactmoment_snowplow_event_id,
    
    mediauser_visitorid_1stparty_cookie,
    mediauser_visitorid_3rdparty_cookie,
    mediauser_marketingid,
    mediauser_adobeid,
    mediauser_snowplow_user_id,
    coalesce(
            nullif(mediauser_marketingid,''), 
            nullif(mediauser_visitorid_1stparty_cookie,''), 
            nullif(mediauser_visitorid_3rdparty_cookie,''),
            nullif(custom__context_mobile_appleIdfv,''),
            nullif(custom__context_mobile_appleIdfa,''),
            nullif(custom__context_mobile_aaid,'')
    ) as mediauser_stitched_user_id,    
    if(
        touchpoint_platform = 'app',
        if(
            nullif(mediauser_crossappid,'') is not null,
            concat(contactmoment_snowplow_app_id, ' | ', mediauser_crossappid),
            nullif(concat(contactmoment_snowplow_app_id, ' | ', coalesce(nullif(mediauser_visitorid_1stparty_cookie,''), nullif(custom__context_mobile_appleIdfv,''), custom__context_mobile_aaid)), concat(contactmoment_snowplow_app_id, ' | '))
        ),
        mediauser_visitorid_1stparty_cookie
    ) as mediauser_visitor_id,
    
    coalesce(nullif(contactsession_id,''), custom__client_session_id) as contactsession_id,
    contactsession_visit_number,

    contactmoment_event_timestamp_cet_raw, 
    contactmoment_event_timestamp_cet, 
    contactmoment_event_date, 
    
    contactmoment_snowplow_event,
    contactmoment_snowplow_event_name,
    contactmoment_snowplow_event_type,

    brand_contentbrand,
    touchpoint_platform,
    touchpoint_platform_vendor,
    touchpoint_touchpointbrand,
    contactmoment_snowplow_platform,
    contactmoment_snowplow_app_id,
    
    -- Referrer
    contactmoment_page_referrer_page_url_host,
    contactmoment_page_referrer_page_url_path,
    contactmoment_page_referrer_page_url_query,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'utm_medium') as contactmoment_page_referrer_page_url_utm_medium,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'utm_source') as contactmoment_page_referrer_page_url_utm_source,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'utm_campaign') as contactmoment_page_referrer_page_url_utm_campaign,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'utm_content') as contactmoment_page_referrer_page_url_utm_content,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'utm_term') as contactmoment_page_referrer_page_url_utm_term,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'fbclid') as contactmoment_page_referrer_page_url_fbclid,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'gclid') as contactmoment_page_referrer_page_url_gclid,
    url_extract_parameter(contactmoment_page_referrer_page_url_query, 'deliveryName') as contactmoment_page_referrer_page_url_delivery_name,
    
    -- Page
    mediacontent_page_id,
    --mediacontent_page_category,
    --mediacontent_page_cms,
    --mediacontent_page_labels,
    mediacontent_page_name,
    mediacontent_page_publishtimestamp,
    mediacontent_page_referrer,
    mediacontent_page_sitesection_1,
    custom__context_page_sitesection1,
    mediacontent_page_sitesection_2,
    mediacontent_page_sitesection_3,
    mediacontent_page_sitesection_4,
    mediacontent_page_title,
    mediacontent_page_topics,
    mediacontent_page_url,
    mediacontent_page_url_anchor,
    mediacontent_page_url_fragment,
    mediacontent_page_url_host,
    mediacontent_page_url_path,
    --mediacontent_page_url_port,
    mediacontent_page_url_query,
    mediacontent_page_url_queryparameters,
    --mediacontent_page_url_scheme,
    mediacontent_page_variant,

    -- component
    offering_component_id,
    offering_component_name,
    offering_component_count,
    offering_component_element_count,
    offering_component_element_position,
    offering_component_element_subtitle,
    offering_component_element_title,
    offering_component_element_type,
    offering_component_orientation,
    offering_component_position,
    offering_component_subtitle,
    offering_component_title,
    offering_component_type,    

    custom__client_session_id,
    custom__client_session_first_event_id,
    custom__client_session_first_event_at,
    custom__context_mobile_appleIdfv,
    custom__context_mobile_appleIdfa,
    custom__context_mobile_androidIdfa,
    custom__context_mobile_aaid,
    contactmoment_link_title,
    custom__context_link_title,
    contactmoment_link_type,
    contactmoment_overlay_title,
    custom__context_overlay_title,
    contactmoment_overlay_interaction,
    custom__context_overlay_interaction,

    import_date
    
from (
    select
        *,
        
        --contactmoment_snowplow_contexts,
        array_sort(map_keys(custom__contactmoment_snowplow_context_to_map)) as custom__contactmoment_snowplow_contexts_extracted,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_app'] as map<varchar,varchar>)) as custom__context_app,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_browser'] as map<varchar,varchar>)) as custom__context_browser,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_consent'] as map<varchar,varchar>)) as custom__context_consent,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_debugger'] as map<varchar,varchar>)) as custom__context_debugger,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_device'] as map<varchar,varchar>)) as custom__context_device,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_link'] as map<varchar,json>)) as custom__context_link,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_overlay'] as map<varchar,varchar>)) as custom__context_overlay,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_page'] as map<varchar,varchar>)) as custom__context_page,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_platform'] as map<varchar,varchar>)) as custom__context_platform,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_user'] as map<varchar,varchar>)) as custom__context_user,
        try(cast(custom__contactmoment_snowplow_context_to_map['client_session'] as map<varchar,varchar>)) as custom__client_session,
        try(cast(custom__contactmoment_snowplow_context_to_map['web_page'] as map<varchar,varchar>)) as custom__web_page,
    
        --== CONTEXT_DETAIL ==--
        --CONTEXT_CLIENT_SESSION
        try(cast(custom__contactmoment_snowplow_context_to_map['client_session'] as map<varchar,varchar>)['sessionId']) as custom__client_session_id,
        try(cast(custom__contactmoment_snowplow_context_to_map['client_session'] as map<varchar,varchar>)['firstEventId']) as custom__client_session_first_event_id,
        try(cast(custom__contactmoment_snowplow_context_to_map['client_session'] as map<varchar,varchar>)['firstEventTimestamp']) as custom__client_session_first_event_at,
        --CONTEXT_LINK--
        try(cast(custom__contactmoment_snowplow_context_to_map['context_link'] as map<varchar,varchar>)['linktitle']) as custom__context_link_title,
        --CONTEXT_MOBILE--
        try(cast(custom__contactmoment_snowplow_context_to_map['mobile_context'] as map<varchar,varchar>)['appleIdfv']) as custom__context_mobile_appleIdfv,
        try(cast(custom__contactmoment_snowplow_context_to_map['mobile_context'] as map<varchar,varchar>)['appleIdfa']) as custom__context_mobile_appleIdfa,
        try(cast(custom__contactmoment_snowplow_context_to_map['mobile_context'] as map<varchar,varchar>)['androidIdfa']) as custom__context_mobile_androidIdfa,
        try(cast(custom__contactmoment_snowplow_context_to_map['mobile_context'] as map<varchar,varchar>)['aaid']) as custom__context_mobile_aaid,
        --CONTEXT_OVERLAY--
        try(cast(custom__contactmoment_snowplow_context_to_map['context_overlay'] as map<varchar,varchar>)['overlaytitle']) as custom__context_overlay_title,
        try(cast(custom__contactmoment_snowplow_context_to_map['context_overlay'] as map<varchar,varchar>)['overlayinteraction']) as custom__context_overlay_interaction,
        --CONTEXT_PAGE--
        try(cast(custom__contactmoment_snowplow_context_to_map['context_page'] as map<varchar,varchar>)['sitesection1']) as custom__context_page_sitesection1
    from (
        select

            contactmoment_snowplow_event_id,
            event as contactmoment_snowplow_event,
            contactmoment_snowplow_event_name,
            contactmoment_snowplow_event_type,
            contactmoment_event_timestamp,
            contactmoment_event_timestamp at time zone 'Europe/Brussels' as contactmoment_event_timestamp_cet_raw, 
            date_parse(date_format(contactmoment_event_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_event_timestamp_cet, 
            date(contactmoment_event_timestamp at time zone 'Europe/Brussels') as contactmoment_event_date, 


            contactsession_id,
            contactsession_visit_number,
            

            mediauser_visitorid_1stparty_cookie,
            mediauser_visitorid_3rdparty_cookie,
            mediauser_marketingid,
            mediauser_adobeid,
            --mediauser_ip_address,
            mediauser_snowplow_user_id,
            mediauser_crossappid,
            


            brand_contentbrand,
            touchpoint_platform,
            touchpoint_platform_vendor,
            touchpoint_touchpointbrand,
            contactmoment_snowplow_platform,
            contactmoment_snowplow_app_id,
        

            contactmoment_snowplow_contexts,
            json_extract(contactmoment_snowplow_contexts, '$.data') as custom__contactmoment_snowplow_context_data,
            cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>) as custom__contactmoment_snowplow_context_data_array,
            transform(cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>), x -> regexp_extract(cast(json_extract(x, '$.schema') as varchar), '(iglu:[\w.]*)\/([\w]*)\/.*', 2)) as custom__contactmoment_snowplow_context_schemas,
            array_distinct(cast(transform(cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>), x -> regexp_extract(cast(json_extract(x, '$.schema') as varchar), '(iglu:[\w.]*)\/([\w]*)\/.*', 2)) as array<varchar>)) as custom__contactmoment_snowplow_context_schemas_to_array,
            array_distinct(transform(cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>), x -> json_extract(x, '$.data'))) as contactmoment_snowplow_context_schemas_data_to_array,
            map(
                array_distinct(cast(transform(cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>), x -> regexp_extract(cast(json_extract(x, '$.schema') as varchar), '(iglu:[\w.]*)\/([\w]*)\/.*', 2)) as array<varchar>)),
                slice(array_distinct(transform(cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>), x -> json_extract(x, '$.data'))), 1, cardinality(array_distinct(cast(transform(cast(json_extract(contactmoment_snowplow_contexts, '$.data') as array<json>), x -> regexp_extract(cast(json_extract(x, '$.schema') as varchar), '(iglu:[\w.]*)\/([\w]*)\/.*', 2)) as array<varchar>)))
                )
            ) as custom__contactmoment_snowplow_context_to_map,

                        
            --contactmoment_viewing_mode,
            contactsession_app_name,
            contactsession_app_version,
            --contactsession_browser_cookies,
            --contactsession_browser_cookiesallowed,
            --contactsession_browser_name,
            --contactsession_device_ismobile,
            --contactsession_device_model,
            --contactsession_device_type,
            --contactsession_page_referrer_mediauser_visitorid_1stparty,
            --contactsession_push_message,
            --contactsession_push_redirect,
            --contactsession_push_title,
            --contactsession_useragent,
            
            -- Referrer
            contactmoment_page_referrer_page_url_host,
            contactmoment_page_referrer_page_url_path,
            nullif(concat('?', contactmoment_page_referrer_page_url_query), '?') as contactmoment_page_referrer_page_url_query,
            
            -- Page
            mediacontent_page_id,
            --mediacontent_page_category,
            --mediacontent_page_cms,
            --mediacontent_page_labels,
            mediacontent_page_name,
            mediacontent_page_publishtimestamp,
            mediacontent_page_referrer,
            mediacontent_page_sitesection_1,
            mediacontent_page_sitesection_2,
            mediacontent_page_sitesection_3,
            mediacontent_page_sitesection_4,
            mediacontent_page_title,
            mediacontent_page_topics,
            mediacontent_page_url,
            mediacontent_page_url_anchor,
            mediacontent_page_url_fragment,
            mediacontent_page_url_host,
            mediacontent_page_url_path,
            --mediacontent_page_url_port,
            mediacontent_page_url_query,
            mediacontent_page_url_queryparameters,
            --mediacontent_page_url_scheme,
            mediacontent_page_variant,
            

            -- components
            offering_component_id,
            offering_component_name,
            offering_component_count,
            offering_component_element_count,
            offering_component_element_position,
            offering_component_element_subtitle,
            offering_component_element_title,
            offering_component_element_type,
            offering_component_orientation,
            offering_component_position,
            offering_component_subtitle,
            offering_component_title,
            offering_component_type,            

            -- contexts
            contactmoment_link_title,
            contactmoment_link_type,


            contactmoment_overlay_title,
            contactmoment_overlay_interaction,
            
            date_parse(date_format(contactmoment_ingest_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_ingest_timestamp_cet, 
            date_parse(date_format(contactmoment_page_referrer_device_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_page_referrer_device_timestamp_cet, 
            date_parse(date_format(contactmoment_snowplow_collector_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_snowplow_collector_timestamp_cet,
            date_parse(date_format(contactmoment_snowplow_derived_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_snowplow_derived_timestamp_cet, 
            date_parse(date_format(contactmoment_snowplow_event_created_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_snowplow_event_created_timestamp_cet, 
            date_parse(date_format(contactmoment_snowplow_event_etl_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_snowplow_event_etl_timestamp_cet, 
            date_parse(date_format(contactmoment_snowplow_event_sent_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_snowplow_event_sent_timestamp_cet, 
            date_parse(date_format(contactmoment_snowplow_user_true_timestamp at time zone 'Europe/Brussels', '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i') as contactmoment_snowplow_user_true_timestamp_cet,
            contactmoment_ingest_timestamp,
            contactmoment_operation_type,
            
            year,
            month,
            day,
            hour(contactmoment_snowplow_collector_timestamp at time zone 'Europe/Brussels') as hour,
            date(concat(
                cast(year as varchar), '-',
                lpad(cast(month as varchar), 2,'0'), '-',
                lpad(cast(day as varchar), 2,'0')
            )) as import_date
        from "marketing_prod"."snowplow_datariver"
    )
)