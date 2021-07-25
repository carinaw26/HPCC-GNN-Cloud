IMPORT STD;


// The trick is to first detach(remove) any sub files, and then you can use the ECL Watch to delete a superfile. Alternatively, you can use the STD.File.DeleteSuperFile function to delete it using ECL.
#OPTION('outputLimit',100);
STD.File.CreateSuperFile('~imgdb3::SF::ahs'); 

SEQUENTIAL
 (STD.File.StartSuperFileTransaction(),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-0::cw'),
 // STD.File.AddSuperFile('~imgdb2::SF::ahs','~ahs-1::cw'),
 // STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-2::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-3::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-4::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-5::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-6::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-7::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-8::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-9::cw'),
////  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-10::cw'),
 // STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-11::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-12::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-13::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-14::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-15::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-16::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-17::cw'),
//  STD.File.AddSuperFile('~imgdb::SF::ahs','~ahs-18::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-19::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-20::cw'),
 // STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-21::cw'),
  STD.File.AddSuperFile('~imgdb3::SF::ahs','~ahs-22::cw'),
  STD.File.FinishSuperFileTransaction()
 );


