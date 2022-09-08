// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

import "iframe-resizer"
// Load images
require.context("../../images", true)

iFrameResize({ log: true }, '.auto-height-iframe')