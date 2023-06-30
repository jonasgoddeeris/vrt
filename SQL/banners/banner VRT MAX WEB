SELECT 
  offering_component_title,
  mediacontent_page_sitesection_1,
  touchpoint_touchpointbrand,
  touchpoint_platform,
  mediacontent_page_name,
  mediacontent_component_target_page_url,
  cet_event_date,
  COUNT(CASE WHEN contactmoment_snowplow_event_name = 'banner_click' THEN 1 END) AS Clicks,
  COUNT(CASE WHEN contactmoment_snowplow_event_name = 'banner_impression' THEN 1 END) AS Impressions
FROM analytics_prod.prep_snowplow_base
WHERE (contactmoment_snowplow_event_name = 'banner_click' OR contactmoment_snowplow_event_name = 'banner_impression')
  AND touchpoint_touchpointbrand = 'vrt nu'
  AND touchpoint_platform = 'web'
  AND cet_event_date >= TIMESTAMP '2023-06-30'
GROUP BY 
  offering_component_title,
  mediacontent_page_sitesection_1,
  touchpoint_touchpointbrand,
  touchpoint_platform,
  mediacontent_page_name,
  mediacontent_component_target_page_url,
  cet_event_date
ORDER BY Impressions DESC;