# delayed jobs

PendingGendImagesController.extend(StatsD::Instrument)
PendingGendImagesController.statsd_count_success(
  :show, 'api.gend_image.create.poll'
)

PendingSrcImagesController.extend(StatsD::Instrument)
PendingSrcImagesController.statsd_count_success(
  :show, 'api.src_image.create.poll'
)

Api::V3::PendingSrcImagesController.extend(StatsD::Instrument)
Api::V3::PendingSrcImagesController.statsd_count_success(
  :show, 'api.v3.src_image.create.poll'
)

Api::V3::PendingGendImagesController.extend(StatsD::Instrument)
Api::V3::PendingGendImagesController.statsd_count_success(
  :show, 'api.v3.gend_image.create.poll'
)

GendImageProcessJob.extend(StatsD::Instrument)
GendImageProcessJob.statsd_count_success(:perform, 'job.gend_image.process')
GendImageProcessJob.statsd_measure(:perform, 'job.gend_image.process.time')

MemeCaptainWeb::AnimatedGifShrinker.extend(StatsD::Instrument)
MemeCaptainWeb::AnimatedGifShrinker.statsd_count_success(
  :shrink, 'animated_gif_shrinker.shrink'
)
MemeCaptainWeb::AnimatedGifShrinker.statsd_measure(
  :shrink, 'animated_gif_shrinker.shrink.runtime'
)

SrcImageNameJob.extend(StatsD::Instrument)
SrcImageNameJob.statsd_measure(:perform, 'job.src_image.name.time')

SrcImageProcessJob.extend(StatsD::Instrument)
SrcImageProcessJob.statsd_count_success(:perform, 'job.src_image.process')
SrcImageProcessJob.statsd_measure(:perform, 'job.src_image.process.time')
