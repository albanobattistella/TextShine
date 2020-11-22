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

using Gtk;

public class ReplaceSelected : TextFunction {

  private MainWindow _win;
  private Editor     _editor;
  private string     _replace_text = "";

  /* Constructor */
  public ReplaceSelected( MainWindow win, bool custom = false ) {

    base( "replace-selected", custom );

    _win = win;

  }

  protected override string get_label0() {
    return( _( "Replace Matched Text" ) );
  }

  public override TextFunction copy( bool custom ) {
    return( new ReplaceSelected( _win, custom ) );
  }

  /* Returns true if matched text exists in the editor */
  public override bool launchable( Editor editor ) {
    return( editor.is_selected() );
  }

  /* Creates the search UI */
  private Box create_widget() {

    var replace = new Entry();
    replace.placeholder_text = _( "Replace With" );
    replace.populate_popup.connect((mnu) => {
      Utils.populate_insert_popup( mnu, replace );
    });

    if( custom ) {

      replace.text = _replace_text;
      replace.changed.connect(() => {
        _replace_text = replace.text;
        custom_changed();
      });

    } else {

      replace.activate.connect(() => {
        _replace_text = replace.text;
        var undo_item = new UndoItem( label );
        do_replace( undo_item );
        _editor.undo_buffer.add_item( undo_item );
      });
      replace.grab_focus();

    }

    var box = new Box( Orientation.HORIZONTAL, 0 );
    box.pack_start( replace, true, true, 5 );

    return( box );

  }

  public override Box? get_widget() {
    return( create_widget() );
  }

  /* Replace all matches with the replacement text */
  private void do_replace( UndoItem? undo_item ) {

    var ranges       = new Array<Editor.Position>();
    var replace_text = Utils.replace_date( _replace_text );

    _editor.get_ranges( ranges );

    for( int i=((int)ranges.length - 1); i>=0; i-- ) {
      var range = ranges.index( i );
      _editor.replace_text( range.start, range.end, replace_text, undo_item );
    }

    /* Hide the widget */
    _win.remove_widget();

  }

  public override void run( Editor editor, UndoItem undo_item ) {
    _editor = editor;
    do_replace( undo_item );
  }

  /* Called when the action button is clicked.  Displays the UI. */
  public override void launch( Editor editor ) {
    _editor = editor;
    if( custom ) {
      do_replace( null );
    } else {
      _win.add_widget( create_widget() );
    }
  }

  public override Xml.Node* save() {
    Xml.Node* node = base.save();
    node->set_prop( "replace", _replace_text );
    return( node );
  }

  public override void load( Xml.Node* node, TextFunctions functions ) {
    base.load( node, functions );
    string? r = node->get_prop( "replace" );
    if( r != null ) {
      _replace_text = r;
    }
  }

}
