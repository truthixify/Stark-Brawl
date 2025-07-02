#[derive(Drop, Destruct)]
pub struct EnemyPath {
    pub path_id: u64,
    pub length: u32,
}

#[derive(Drop, Destruct, Copy)]
pub struct EnemyPathStep {
    pub x: u32,
    pub y: u32,
}

mod errors {
    pub const IndexOutOfBounds: felt252 = 'IndexOutOfBounds';
    pub const MismatchedLengths: felt252 = 'MismatchedLengths';
}

#[generate_trait]
pub trait EnemyPathSystem {
    fn new(path_id: u64, xs: Array<u32>, ys: Array<u32>) -> EnemyPath;
    fn get_step(xs: Array<u32>, ys: Array<u32>, index: u32) -> EnemyPathStep;
    fn length(path: EnemyPath) -> u32;
}

impl EnemyPathImpl of EnemyPathSystem {
    fn new(path_id: u64, xs: Array<u32>, ys: Array<u32>) -> EnemyPath {
        assert(xs.len() == ys.len(), errors::MismatchedLengths);
        EnemyPath { path_id, length: xs.len().into() }
    }

    fn get_step(xs: Array<u32>, ys: Array<u32>, index: u32) -> EnemyPathStep {
        assert(index < xs.len(), errors::IndexOutOfBounds);
        let idx: usize = index.into();
        EnemyPathStep {
            x: *xs.at(idx),
            y: *ys.at(idx),
        }
    }

    fn length(path: EnemyPath) -> u32 {
        path.length
    }
}

#[cfg(test)]
mod tests {
    use super::*;


    #[test]
    fn test_path_creation_and_access() {
        let mut xs = ArrayTrait::new();
        let mut ys = ArrayTrait::new();
        xs.append(10_u32);
        xs.append(20_u32);
        xs.append(30_u32);
        ys.append(1_u32);
        ys.append(2_u32);
        ys.append(3_u32);

        let path = EnemyPathImpl::new(5_u64, xs.clone(), ys.clone());
        assert(path.length == 3_u32, 'Incorrect length');

        let step0 = EnemyPathImpl::get_step(xs.clone(), ys.clone(), 0_u32);
        assert(step0.x == 10_u32, 'Step 0 x mismatch');
        assert(step0.y == 1_u32, 'Step 0 y mismatch');

        let step2 = EnemyPathImpl::get_step(xs.clone(), ys.clone(), 2_u32);
        assert(step2.x == 30_u32, 'Step 2 x mismatch');
        assert(step2.y == 3_u32, 'Step 2 y mismatch');
    }

    #[test]
    #[should_panic]
    fn test_step_access_out_of_bounds_panics() {
        let mut xs = ArrayTrait::new();
        let mut ys = ArrayTrait::new();
        xs.append(10_u32);
        ys.append(1_u32);
        let _ = EnemyPathImpl::get_step(xs, ys, 1_u32); //Only index 0 is valid
    }

    #[test]
    #[should_panic]
    fn test_mismatched_lengths_panics() {
        let mut xs = ArrayTrait::new();
        let mut ys = ArrayTrait::new();
        xs.append(10_u32);
        //ys is empty
        let _ = EnemyPathImpl::new(1_u64, xs, ys);
    }

    #[test]
    fn test_zero_length_path() {
        let xs = ArrayTrait::new();
        let ys = ArrayTrait::new();
        let path = EnemyPathImpl::new(42_u64, xs.clone(), ys.clone());
        assert(path.length == 0_u32, 'ZeroLen');
    }

}