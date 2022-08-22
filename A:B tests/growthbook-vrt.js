<script>
window.GROWTHBOOK_CONFIG = {
  // Optional logged-in user id
  userId: digitalData.user.marketingId,
  // Impression tracking callback (e.g. Segment, Mixpanel, GA)
  track: function(experimentId, variationId) {
    analytics.track("Experiment Viewed", {
      experimentId,
      variationId
    })
    window.digitalData.page = new Array(window.digitalData.page) || [];
    digitalData.page.push({
     'experiment_id': 'growthbook' + '-' + experimentId,
     'variation_id': 'growthbook' + '-' + variationId
    });

  }
}
</script>
<script async src="https://cdn.growthbook.io/js/key_prod_edabf6ad2c41cab3.js"></script>