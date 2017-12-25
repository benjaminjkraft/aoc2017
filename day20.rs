use std::cmp::Ordering;
use std::convert::From;
use std::io;
use std::io::Read;

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone)]
struct V(i64, i64, i64);

impl V {
    fn add(&mut self, other: &V) {
        self.0 += other.0;
        self.1 += other.1;
        self.2 += other.2;
    }

    fn dist(&self) -> i64 {
        self.0.abs() + self.1.abs() + self.2.abs()
    }
}

impl From<String> for V {
    fn from(s: String) -> Self {
        let mut split = s[1..(s.len() - 1)].split(",");
        V(split.next().unwrap().parse().unwrap(),
            split.next().unwrap().parse().unwrap(),
            split.next().unwrap().parse().unwrap())
    }
}

#[derive(PartialEq, Eq, Clone)]
struct Particle {
    a: V,
    v: V,
    x: V,
    i: usize,
}

impl Particle {
    fn advance(&mut self) {
        self.v.add(&self.a);
        self.x.add(&self.v);
    }

    fn ready(&self) -> bool {
        (((self.a.0 == 0 && self.v.0 == 0) ||
          (self.a.0 == 0 && self.v.0.signum() == self.x.0.signum()) ||
          (self.a.0.signum() == self.v.0.signum() && self.v.0.signum() == self.x.0.signum())) &&
         ((self.a.1 == 0 && self.v.1 == 0) ||
          (self.a.1 == 0 && self.v.1.signum() == self.x.1.signum()) ||
          (self.a.1.signum() == self.v.1.signum() && self.v.1.signum() == self.x.1.signum())) &&
         ((self.a.2 == 0 && self.v.2 == 0) ||
          (self.a.2 == 0 && self.v.2.signum() == self.x.2.signum()) ||
          (self.a.2.signum() == self.v.2.signum() && self.v.2.signum() == self.x.2.signum())))
    }
}

impl From<(usize, String)> for Particle {
    fn from((i, s): (usize, String)) -> Self {
        let mut split = s.split(", ");
        let raw_p = split.next().unwrap()[2..].to_string();
        let raw_v = split.next().unwrap()[2..].to_string();
        let raw_a = split.next().unwrap()[2..].to_string();
        Particle {
            a: V::from(raw_a),
            v: V::from(raw_v),
            x: V::from(raw_p),
            i: i,
        }
    }
}

// Only correct once ready!
impl Ord for Particle {
    fn cmp(&self, other: &Particle) -> Ordering {
        [self.a.dist(), self.v.dist(), self.x.dist()].cmp(
            &[other.a.dist(), other.v.dist(), other.x.dist()])
    }
}

impl PartialOrd for Particle {
    fn partial_cmp(&self, other: &Particle) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn closest(starting: &Vec<Particle>) -> usize {
    let mut particles = starting.clone();
    while particles.iter().any(|ref particle| !particle.ready()) {
        particles.iter_mut().for_each(|ref mut particle| particle.advance());
    }
    particles.sort();
    particles[0].i
}

fn clear_collisions(particles: &mut Vec<Particle>) {
    particles.sort_by_key(|ref particle| particle.x.clone());
    // Cribbed from Vec::dedup_by_key
    let mut index = 0;
    while index < particles.len() {
        let mut offset = 0;
        while index + offset + 1 < particles.len() &&
              particles[index].x == particles[index + offset + 1].x {
            offset += 1;
        }
        if offset > 0 {
            for _ in 0..(offset+1) {
                particles.remove(index);
            }
        } else {
            index += 1;
        }
    }
}

fn collide(starting: &Vec<Particle>) -> usize {
    let mut particles = starting.clone();
    clear_collisions(&mut particles);
    // Not actually the correct condition, but apparently close enough.
    while particles.iter().any(|ref particle| !particle.ready()) {
        particles.iter_mut().for_each(|ref mut particle| particle.advance());
        clear_collisions(&mut particles);
    }
    particles.len()
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let starting: Vec<Particle> = input.lines()
                                       .map(str::to_string)
                                       .enumerate()
                                       .map(Particle::from)
                                       .collect();
    println!("{}", closest(&starting));
    println!("{}", collide(&starting));
}
