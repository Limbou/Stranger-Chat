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
   pod 'Nimble', '~> 7.3.1'
   pod 'Quick', '~> 1.3.2'
 end

 def ui_pods
   pod 'SnapKit', '~> 4.2.0'
 end

 def other_pods
   pod 'SwiftLint'
 end


target 'Stranger-Chat' do
  use_frameworks!
  firebase_pods
  rx_pods
  ui_pods
  other_pods
  

  target 'Stranger-ChatTests' do
    inherit! :search_paths
    test_pods
  end

end
