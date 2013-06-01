
describe("Faker", function() {
  it("binds to the window", function() {
    expect(Faker).toBeDefined();
  });
  
  describe("Faker.Lorem", function() {
    
    it("binds to Faker", function() {
      expect(Faker.Lorem).toBeDefined();  
    });

    describe("#word", function() {
      it("returns a single word", function() {
        expect(Faker.Lorem.word()).toMatch(/^[a-zA-Z]+$/);
      });
    });

    describe("#words", function() {
      it("returns an array of words based on quantity", function() {
        expect( $.isArray(Faker.Lorem.words(3)) ).toBeTruthy();
      });

      it("throws an error when the quantity is not an integer", function() {
        expect(function(){ 
          Faker.Lorem.words('blah') 
        }).toThrow();
      });
    });

    describe("#characters", function() {
      it("returns a string of characters", function() {
        expect(Faker.Lorem.characters(16)).toMatch(/^[a-zA-Z]{16}$/);
      });

      describe("as array", function() {
        it("returns an array of characters", function() {
          expect( $.isArray(Faker.Lorem.characters(16, true)) ).toBeTruthy();
        });
      });

      it("throws an error when the quantity is not an integer", function() {
        expect(function(){ 
          Faker.Lorem.characters('blah') 
        }).toThrow();
      });
    });

    describe("#sentence", function() {
      it("returns a string representation", function() {
        expect(Faker.Lorem.sentence()).toMatch(/^(([a-zA-Z]+)\s?)+\.?$/);
      });

      describe("options", function() {
        describe("length", function() {
          it("iterpretes the first argument as length", function() {
            expect(Faker.Lorem.sentence(3)).toMatch(/^(([a-zA-Z]+)\s?){3}\.?$/);
          });

          it("finds length from hash options", function() {
            expect(Faker.Lorem.sentence({
              length: 3 
            })).toMatch(/^(([a-zA-Z]+)\s?){3}\.?$/);
          });
        });

        describe("startWithCapital", function() {
          it("returns a string that starts capitalized", function() {
            expect(Faker.Lorem.sentence()).toMatch(/^[^a-z](([a-zA-Z]+)\s?)+\.?$/);
          });

          it("returns a string that does NOT start capitalized", function() {
            expect(Faker.Lorem.sentence({
              startWithCapital: false
            })).toMatch(/^[^A-Z](([a-zA-Z]+)\s?)+\.?$/);
          });
        });

        describe("endWithPeriod", function() {
          it("returns a string that ends with a period", function() {
            expect(Faker.Lorem.sentence()).toMatch(/^(([a-zA-Z]+)\s?)+\.?$/);
          });

          it("returns a string that does NOT end with a period", function() {
            expect(Faker.Lorem.sentence({
              endWithPeriod: false
            })).toMatch(/^(([a-zA-Z]+)\s?)+$/);
          });
        });
      });
    });

    describe("#sentences", function() {
      it("returns a string of multiple sentences", function() {
        expect(Faker.Lorem.sentences(3)).toMatch(/^((([a-zA-Z]+)\s?)+\.?)+$/);
      });
    });
  });
});


describe("$.fn.faker", function() {
  it("binds to the jQuery object", function() {
    expect($).toBe(jQuery);
    expect($.fn.faker).toBeDefined();
  });
});