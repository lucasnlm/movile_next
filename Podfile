source 'https://github.com/CocoaPods/Specs'

platform :ios, '8.0'

inhibit_all_warnings!
use_frameworks!

target 'MovileNext', :exclusive => true do
    # Add Application pods here
    pod 'Alamofire'
    pod 'Kingfisher', '~> 1.4'
    pod 'Argo'
    pod 'Result'
    pod 'TagListView'
    pod 'FloatRatingView', :git => 'https://github.com/strekfus/FloatRatingView.git'
    pod 'BorderedView'
    pod 'OverlayView', :git => 'https://github.com/marcelofabri/OverlayView.git'
    pod 'TraktModels', :git => 'http://github.com/marcelofabri/TraktModels.git'
end

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Nimble'
  pod 'OHHTTPStubs'
end

