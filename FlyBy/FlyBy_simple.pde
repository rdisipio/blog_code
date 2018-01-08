import java.io.*;
import traer.physics.*;

Boolean recording = false;
String outdir = "/Users/disipio/Documents/Processing/flyby_simple/";

float kg = 1.;
float km = 1e3;
float G_N = 6.67e-11; // m^3 kg^−1 s^−2
float AU = 1.496e11; // m

float m_sun = 1.989e30*kg;
float m_earth = 5.9e24*kg; // used for normalization
float m_jupiter = 1e29*kg; // increased (1.9e27*kg)
float m_saturn = 1e29*kg; // 5e26*kg
float m_uranus = 1e29*kg; // 8.26e25
float m_neptune = 1e29*kg; // 1e26*kg
float m_pluto = 1.3e22*kg;
float m_probe = 1e3*kg;

float mu_solar_system = G_N * m_sun;
float mu_solar_system_reduced = mu_solar_system / m_earth;

float r_earth = 1.;
float r_jupiter = 5.;
float r_saturn = 9.;
float r_uranus = 20.;
float r_neptune = 29;
float r_pluto = 39;

ParticleSystem physics;
Particle sun;
Particle jupiter;
Particle saturn;
Particle uranus;
Particle neptune;
Particle pluto;
Particle probe;

//float r_0 = ( width/70 );

Boolean probe_launched = false;

FileWriter file;

void setup()
{
  size( 800, 800 );
  smooth();
  
  try {
    file = new FileWriter( outdir + "flyby.txt", true );
  }
  catch( Exception e ) {
  }
  
  float r_0 = ( width/100 );
  
  physics = new ParticleSystem( 0., 0. );
  physics.setIntegrator( ParticleSystem.RUNGE_KUTTA );
    
  sun = physics.makeParticle( m_sun/m_earth, width/2, height/2, 0 );
  sun.makeFixed();
  
  jupiter = physics.makeParticle( m_jupiter/m_earth, width/2 + r_0*r_jupiter, height/2., 0 );
  float v_0 = -sqrt(mu_solar_system_reduced/r_jupiter/r_0);
  jupiter.velocity().set( 0., v_0, 0. );
  
  saturn  = physics.makeParticle( m_saturn/m_earth, width/2 + r_0*r_saturn , height/2, 0 );
  saturn.velocity().set( 0, -sqrt(mu_solar_system_reduced/r_saturn/r_0), 0. );

  uranus  = physics.makeParticle( m_uranus/m_earth, width/2 + r_0*r_uranus , height/2, 0 );
  uranus.velocity().set( 0, -sqrt(mu_solar_system_reduced/r_uranus/r_0), 0. );
  
  neptune  = physics.makeParticle( m_neptune/m_earth, width/2 + r_0*r_neptune , height/2, 0 );
  neptune.velocity().set( 0, -sqrt(mu_solar_system_reduced/r_neptune/r_0), 0. );

  pluto  = physics.makeParticle( m_pluto/m_earth, width/2 + r_0*r_pluto , height/2, 0 );
  pluto.velocity().set( 0, -sqrt(mu_solar_system_reduced/r_pluto/r_0), 0. );

  physics.makeAttraction( sun, jupiter, G_N, r_0/100 );
  physics.makeAttraction( sun, saturn, G_N, r_0/100 );
  physics.makeAttraction( sun, uranus, G_N, r_0/100 );
  physics.makeAttraction( sun, neptune, G_N, r_0/100 );
  physics.makeAttraction( sun, pluto, G_N, r_0/100 );
  
  println( "Start:" );
  println( "Speed of earth at perihelion = " + sqrt(mu_solar_system/AU)/km + " km/s");
  println( "Jupiter initial velocity: " + sqrt(mu_solar_system/(r_jupiter*AU))/km + " km/s" );
}

void keyPressed() {  
  // If we press r, start or stop recording!
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
  
  // launch
  if (key=='l' ) {
    float r_0 = ( width/100 );
    //float v_0 = 11186.; 
    float v_0 = -sqrt(mu_solar_system_reduced/r_earth/r_0) * 1.27;
    
    probe = physics.makeParticle( m_probe/m_earth,  width/2 + r_0*r_earth, height/2, 0 );
    probe.velocity().set( 0, v_0, 0. );
    
    physics.makeAttraction( probe, sun,     G_N, r_0/100 );
    physics.makeAttraction( probe, jupiter, G_N, r_0/10 );
    physics.makeAttraction( probe, saturn,  G_N, r_0/10 );
   
    probe_launched = true;
  }
  
  // kill
  if (key=='k') { 
      physics.removeParticle(probe);
      probe_launched = false;
  }
  
}

void draw()
{
   physics.tick(2000);
   background( 0 );
   
   if (probe_launched==true) {
   }
   
   color y = color( 255, 204, 0);
   fill(y);
   noStroke();
   ellipse( sun.position().x(), sun.position().y(), 20, 20 );
   
   color c = color( 255, 150, 100);
   fill(c);
   ellipse( jupiter.position().x(),  jupiter.position().y(), 10, 10 );  
   
   color c1 = color( 100, 110, 100);
   fill(c1);
   ellipse( saturn.position().x(),  saturn.position().y(),   25, 5 ); 
   color c2 = color( 200, 150, 100 );
   fill(c2); 
   ellipse( saturn.position().x(),  saturn.position().y(),   10, 10 );
  
   fill(c1);
  ellipse( uranus.position().x(),  uranus.position().y(),   5, 15 ); 
  color b2 = color( 0, 200, 200);
  fill(b2);
  ellipse( uranus.position().x(),  uranus.position().y(),   10, 10 );
  
  color b3 = color( 0, 0, 250);
  fill(b3);
  ellipse( neptune.position().x(),  neptune.position().y(), 10, 10 );
  
  //color r2 = color( 255, 0, 0);
  fill(y);
  ellipse( pluto.position().x(),  pluto.position().y(), 3, 3 );
   
   
    if (probe_launched==true) {
    color w = color(255,255,255);
    fill(w);
    noStroke();
    ellipse( probe.position().x(), probe.position().y(), 5, 5 );
    
    float x_p = probe.position().x();
    float y_p = probe.position().y();
    float v_x = probe.velocity().x();
    float v_y = probe.velocity().y();
    
    float r_p = sqrt( x_p*x_p + y_p*y_p );
    float v_p = sqrt(  v_x*v_x + v_y*v_y );
    
    float v = sqrt(mu_solar_system/(r_p*AU))/km;
    
    println( "V_p = " + v + " km/s \n");
    
    String data = "" + v;
    try {
      file.write( data );
    }
    catch( Exception e ) {}
  }
  
  
   if (recording) {
    saveFrame( outdir + "frames/frames####.jpg");
  }
  
 }