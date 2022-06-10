component {
	
	public string function longdate( date when ) {
		return dateFormat( when, 'long' ) & " at " & timeFormat( when, 'long' );
	}
	
}
