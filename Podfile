platform :ios, '10.0'
inhibit_all_warnings!

 def firebase_pods
    pod 'Firebase/Core'
 end

 def rx_pods
    pod 'RxCocoa', '~> 5'
    pod 'RxSwift', '~> 5'
 end

 def test_pods
   pod 'Nimble', '~> 7.3.4'
   pod 'Quick', '~> 1.3.4'
 end

 def other_pods
   pod 'SwiftLint'
   pod 'Localize-Swift', '~> 2.0'
 end


target 'Stranger-Chat' do
  use_frameworks!
  firebase_pods
  rx_pods
  other_pods
  

  target 'Stranger-ChatTests' do
    inherit! :search_paths
    test_pods
  end

end
