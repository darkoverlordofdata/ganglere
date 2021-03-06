var gulp = require('gulp');
var server = require('gulp-webserver');
var logger = require('morgan');
var path = process.argv[2] ? process.argv[2] : 'web';

gulp.src('./')
.pipe(server({
	host: 'localhost',
	port: 0xd16a,
	livereload: true,
	directoryListing: false,
	open: "http://localhost:53610/"+path,
	middleware: logger('dev')
}));
