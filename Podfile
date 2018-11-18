platform :ios, '10.0'
inhibit_all_warnings!

 def firebase_pods
    pod 'Firebase/Core'
 end

 def rx_pods
    pod 'RxCocoa', '~> 4.4.0'
    pod 'RxSwift', '~> 4.4.0'
 end

 def test_pods
   pod 'Nimble-Snapshots', '~> 6.9.0'
   pod 'Nimble', '~> 7.3.1'
   pod 'Quick', '~> 1.3.2'
   pod 'Sourcery', '~> 0.15'
 end

 def ui_pods
   pod 'SnapKit', '~> 4.2.0'
 end


target 'Stranger-Chat' do
  use_frameworks!
  firebase_pods
  rx_pods
  test_pods


  target 'Stranger-ChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Stranger-ChatUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
