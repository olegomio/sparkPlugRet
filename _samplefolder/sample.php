<?php
/**
 * Plugin Name: 
 * Description: 
 * Version: 1.0.0
 * Author: 
 * 05/23
 * @package Plugin Name
 * 
 */

// add backend "View Details" Link for more Information about the Plugin 

add_filter(
    'plugin_row_meta',
    function( $plugin_meta, $plugin_file, $plugin_data ) {
        if ( __FILE__ === path_join( WP_PLUGIN_DIR, $plugin_file ) ) {

            $url = plugins_url( 'readme.txt', __FILE__ );

            $plugin_meta[] = sprintf(
                '<a href="%s" class="thickbox open-plugin-details-modal" aria-label="%s" data-title="%s">%s</a>',
                add_query_arg( 'TB_iframe', 'true', $url ),
                esc_attr( sprintf( __( 'More information about %s' ), $plugin_data['Name'] ) ),
                esc_attr( $plugin_data['Name'] ),
                __( 'View details' )
            );
        }
        return $plugin_meta;
    },
    10,
    3
);


// Enqueue JavaScript File

function plugin_script() {
    wp_enqueue_script( 'plugin_script', plugin_dir_url( __FILE__ ) . 'js/_script.js', array( 'jquery' ), '1.0.0', true );
}
add_action( 'wp_enqueue_scripts', 'plugin_script' );


// Enqueue CSS File

function plugin_style() {
    wp_enqueue_style( 'plugin_style', plugin_dir_url( __FILE__ ) . 'css/_style.css' );
}
add_action( 'wp_enqueue_scripts', 'plugin_style' );



// Core Function

add_action( 'wp', 'plugin_function');
function plugin_function() {

    // your code

}