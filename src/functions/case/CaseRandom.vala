/*
* Copyright (c) 2020 (https://github.com/phase1geo/TextShine)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Trevor Williams <phase1geo@gmail.com>
*/

public class CaseRandom : TextFunction {

  /* Constructor */
  public CaseRandom( bool custom = false ) {
    base( "case-random", custom );
  }

  protected override string get_label0() {
    return( _( "Random Case" ) );
  }

  public override TextFunction copy( bool custom ) {
    return( new CaseRandom( custom ) );
  }

  /* Perform the transformation */
  public override string transform_text( string original, int cursor_pos ) {
    string[] parts;
    string   orig;
    if( CaseCamel.is_camel_case( original, out parts ) ) {
      orig = string.joinv( " ", parts );
    } else if( CaseSnake.is_snake_case( original, out parts ) ) {
      orig = string.joinv( " ", parts );
    } else {
      orig = original;
    }
    var str  = "";
    var rand = new Rand();
    for( int i=0; i<orig.char_count(); i++ ) {
      var ch = orig.get_char( orig.index_of_nth_char( i ) );
      str += (rand.int_range( 0, 2 ) == 0) ? ch.tolower().to_string() : ch.toupper().to_string();
    }
    return( str );
  }

}
