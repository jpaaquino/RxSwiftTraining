import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
var str = "Hello, playground"

let obs = Observable.just(1)
let obs2 = Observable.of(1,2,3)
let obs3 = Observable.of([1,2,3])// element is array
let obs4 = Observable.from([1,2,3,4,5])// element id Int

print("---obs2----")
obs2.subscribe {
    event in
    print(event)
}
print("---obs4----")
obs4.subscribe {
    event in
    print(event)
}

print("---obs3----")
obs3.subscribe {
    event in
    print(event)
}

print("---obs4 onNext----")
let subs4 = obs4.subscribe(onNext: {
    element in
    print(element)
})

subs4.dispose()

Observable<String>.create { observer in
    observer.onNext("A")
    return Disposables.create()
}

print("-------Subjects---------")
// Both Observable and Observer

print("---PublishSubjects----")
//No need for initial value
let subject = PublishSubject<String>()
subject.onNext("Issue 1")//Not called because subscribed after

subject.subscribe { event in
    print(event)
}
subject.onNext("Issue 2")
subject.dispose()

print("---BahaviourSubjects----")
//Need an initial value
let behSubject = BehaviorSubject(value: "Initial value")//Gets called because BahaviourSubject points to the last event

behSubject.subscribe {
    event in
    print(event)
}

behSubject.onNext("Issue 1")

print("---ReplaySubjects----")
//Emmits last n events

let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.onNext("Issue 1")
replaySubject.onNext("Issue 2")
replaySubject.onNext("Issue 3")
replaySubject.subscribe {
    print($0)
}
replaySubject.onNext("Issue 4")
replaySubject.onNext("Issue 5")
replaySubject.onNext("Issue 6")
print("subs 2")
replaySubject.subscribe {
    print($0)
}

print("---BehaviorRelay----")
//Does not need initial value but can have one
//Subs gets called when value changes(gets new value)

let relay = BehaviorRelay(value: ["Item 1"])
relay.accept(relay.value + ["New value"])


relay.asObservable().subscribe({
    print($0)
})

//Ignore
//Ignores elements but not onCompleted

let strike = PublishSubject<String>()
let bag = DisposeBag()
strike.ignoreElements().subscribe {
    _ in
    print("Subscription called")
}.disposed(by: bag)

strike.onNext("A")
strike.onNext("B")
strike.onNext("C")
strike.onCompleted()

//ElementAt
strike.elementAt(2).subscribe {
    _ in
    print("You're out")
}.disposed(by: bag)

strike.onNext("1")
strike.onNext("2")
strike.onNext("3")// Only called here
strike.onNext("4")
strike.onNext("5")

print("---FILTER---")
Observable.of(1,2,3,4,76,77).filter {
    $0 % 2 == 0
}.subscribe(onNext: {
    print($0)
    }).disposed(by: bag)

//Skip
print("---SKIP---")
Observable.of(1,2,3,4,76,77).skip(2).subscribe(onNext: {
print($0)
}).disposed(by: bag)

//Skip While
print("---SKIP WHILE---")
Observable.of(1,2,44,4,76,77).skipWhile {$0 < 7 }.subscribe(onNext: {
print($0)//skips 1,2
}).disposed(by: bag)

print("---SKIP UNTIL---")
//Waits for a trigger

let untilSubject = PublishSubject<String>()
let trigger = PublishSubject<String>()

untilSubject.skipUntil(trigger).subscribe(onNext: {
    print($0)
    }).disposed(by: bag)

untilSubject.onNext("A")
untilSubject.onNext("B")
trigger.onNext("X")
untilSubject.onNext("C")//only prints this because its after trigger

print("---TAKE---")
//take first n items

Observable.of(1,2,3,4,5,6).take(3).subscribe(onNext: {
print($0)
}).disposed(by: bag)

print("---TAKE WHILE---")

Observable.of(8,2,3,4,5,6).takeWhile{return $0 % 2 == 0}.subscribe(onNext: {
print($0)
}).disposed(by: bag)//prints 8,2

print("---TAKE UNTIL---")
let takeUntilSubject = PublishSubject<String>()
let newTrigger = PublishSubject<String>()

takeUntilSubject.takeUntil(newTrigger).subscribe(onNext: {
    print($0)
    }).disposed(by: bag)

takeUntilSubject.onNext("A")
takeUntilSubject.onNext("B")//prints A,B
newTrigger.onNext("X")
takeUntilSubject.onNext("C")
