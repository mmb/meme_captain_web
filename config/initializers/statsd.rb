# delayed jobs

PendingSrcImagesController.extend(StatsD::Instrument)
PendingSrcImagesController.statsd_count_success(
  :show, 'api.src_image.create.poll')

GendImageProcessJob.extend(StatsD::Instrument)
GendImageProcessJob.statsd_count_success(:perform, 'job.gend_image.process')
GendImageProcessJob.statsd_measure(:perform, 'job.gend_image.process.time')

SrcImageNameJob.extend(StatsD::Instrument)
SrcImageNameJob.statsd_measure(:perform, 'job.src_image.name.time')

SrcImageProcessJob.extend(StatsD::Instrument)
SrcImageProcessJob.statsd_count_success(:perform, 'job.src_image.process')
SrcImageProcessJob.statsd_measure(:perform, 'job.src_image.process.time')
