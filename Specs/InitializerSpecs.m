#import "SpecHelper.h"
#import "InitializerFixtures.h"

SPEC_BEGIN(InitializerSpecs)
__block ApplauseJSObjectionInjector *injector = nil;

beforeEach(^{
    injector = [ApplauseJSObjection createInjector];
});

it(@"instantiates the object with the default initializer arguments", ^{
    ViewController *controller = [injector getObject:[ViewController class]];
    
    [[controller.nibName should] equal:@"MyNib"];
    assertThat(controller.bundle, nilValue());
    [[controller.car should] beMemberOfClass:[Car class]];
});

it(@"will override the default arguments if arguments are passed to the injector", ^{
    ViewController *controller = [injector getObjectWithArgs:[ViewController class], @"AnotherNib", @"pretendBundle", nil];
    
    [[controller.nibName should] equal:@"AnotherNib"];
    [[controller.bundle should] equal:@"pretendBundle"];
    [[controller.car should] beMemberOfClass:[Car class]];    
});

it(@"is OK to register an object with an initializer without any default arguments", ^{
    ConfigurableCar *car = [injector getObjectWithArgs:[ConfigurableCar class], @"Passat", [NSNumber numberWithInt:200], [NSNumber numberWithInt:2002], nil];
    
    [[car.horsePower should] equal:[NSNumber numberWithInt:200]];
    [[car.model should] equal:@"Passat"];
    [[car.year should] equal:[NSNumber numberWithInt:2002]];
    [[car.engine should] beMemberOfClass:[Engine class]];    
});

it(@"raises an exception if the initializer is not valid", ^{
   [[theBlock(^{
       [injector getObject:[BadInitializer class]];
   }) should] raiseWithReason:@"Could not find initializer 'initWithNonExistentInitializer' on BadInitializer"];
});

it(@"supports initializing an object with a class method", ^{
    Truck *truck = [injector getObjectWithArgs:[Truck class], @"Ford", nil];

    [[truck shouldNot] beNil];
    [[truck.name should] equal:@"Ford"];
});

it(@"filters the init initializer as a class initializer option", ^{
    FilterInitInitializer *obj = [injector getObject:[FilterInitInitializer class]];
    [[obj shouldNot] beNil];
});

SPEC_END