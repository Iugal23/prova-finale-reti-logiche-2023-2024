-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity double_tb is
end double_tb;

architecture double_tb_arch of double_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

    constant SCENARIO_LENGTH_1 : integer := 14;
    type scenario_type_1 is array (0 to SCENARIO_LENGTH_1*2-1) of integer;

    -- first tb

    signal scenario_input_1 : scenario_type_1 := (128, 0,  64, 0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 100,  0, 1,  0, 0,  0, 5,  0, 23,  0, 200,  0,   0,  0 );
    signal scenario_full_1  : scenario_type_1 := (128, 31, 64, 31, 64, 30, 64, 29, 64, 28, 64, 27, 64, 26, 100, 31, 1, 31, 1, 30, 5, 31, 23, 31, 200, 31, 200, 30 );
 
    constant SCENARIO_ADDRESS_1 : integer := 1234;
    
    -- second tb
    constant SCENARIO_LENGTH_2 : integer := 412;
    type scenario_type_2 is array (0 to SCENARIO_LENGTH_2*2-1) of integer;

    signal scenario_input_2 : scenario_type_2 := (39, 0, 0, 0, 0, 0, 74, 0, 80, 0, 50, 0, 74, 0, 0, 0, 0, 0, 20, 0, 188, 0, 33, 0, 0, 0, 221, 0, 130, 0, 175, 0, 186, 0, 0, 0, 44, 0, 184, 0, 104, 0, 1, 0, 228, 0, 158, 0, 51, 0, 122, 0, 163, 0, 0, 0, 216, 0, 159, 0, 192, 0, 0, 0, 48, 0, 0, 0, 0, 0, 162, 0, 0, 0, 238, 0, 7, 0, 0, 0, 67, 0, 0, 0, 9, 0, 0, 0, 129, 0, 207, 0, 37, 0, 208, 0, 240, 0, 0, 0, 180, 0, 0, 0, 101, 0, 0, 0, 25, 0, 192, 0, 171, 0, 0, 0, 47, 0, 39, 0, 25, 0, 0, 0, 77, 0, 91, 0, 104, 0, 25, 0, 186, 0, 70, 0, 155, 0, 54, 0, 176, 0, 255, 0, 62, 0, 0, 0, 40, 0, 177, 0, 144, 0, 214, 0, 1, 0, 213, 0, 139, 0, 138, 0, 134, 0, 57, 0, 176, 0, 45, 0, 113, 0, 191, 0, 231, 0, 35, 0, 0, 0, 0, 0, 128, 0, 0, 0, 105, 0, 85, 0, 159, 0, 159, 0, 68, 0, 193, 0, 69, 0, 6, 0, 119, 0, 191, 0, 0, 0, 91, 0, 154, 0, 240, 0, 233, 0, 0, 0, 55, 0, 31, 0, 78, 0, 31, 0, 17, 0, 224, 0, 30, 0, 6, 0, 0, 0, 41, 0, 60, 0, 0, 0, 85, 0, 135, 0, 0, 0, 181, 0, 218, 0, 195, 0, 158, 0, 0, 0, 0, 0, 251, 0, 0, 0, 170, 0, 127, 0, 206, 0, 249, 0, 61, 0, 0, 0, 161, 0, 110, 0, 0, 0, 0, 0, 141, 0, 142, 0, 96, 0, 62, 0, 242, 0, 169, 0, 79, 0, 238, 0, 28, 0, 90, 0, 44, 0, 148, 0, 30, 0, 207, 0, 0, 0, 0, 0, 0, 0, 11, 0, 94, 0, 104, 0, 0, 0, 109, 0, 0, 0, 220, 0, 174, 0, 132, 0, 98, 0, 117, 0, 252, 0, 128, 0, 51, 0, 198, 0, 0, 0, 69, 0, 44, 0, 0, 0, 25, 0, 61, 0, 0, 0, 0, 0, 239, 0, 133, 0, 204, 0, 202, 0, 171, 0, 0, 0, 63, 0, 79, 0, 0, 0, 25, 0, 244, 0, 199, 0, 35, 0, 37, 0, 139, 0, 51, 0, 188, 0, 230, 0, 23, 0, 0, 0, 102, 0, 124, 0, 127, 0, 174, 0, 184, 0, 0, 0, 92, 0, 187, 0, 0, 0, 177, 0, 134, 0, 126, 0, 0, 0, 146, 0, 0, 0, 27, 0, 44, 0, 187, 0, 167, 0, 0, 0, 105, 0, 180, 0, 192, 0, 137, 0, 42, 0, 200, 0, 101, 0, 210, 0, 0, 0, 172, 0, 100, 0, 202, 0, 0, 0, 215, 0, 177, 0, 0, 0, 0, 0, 229, 0, 25, 0, 222, 0, 69, 0, 225, 0, 0, 0, 51, 0, 167, 0, 119, 0, 0, 0, 203, 0, 28, 0, 0, 0, 27, 0, 204, 0, 107, 0, 56, 0, 236, 0, 129, 0, 221, 0, 224, 0, 8, 0, 0, 0, 228, 0, 14, 0, 43, 0, 109, 0, 54, 0, 210, 0, 16, 0, 18, 0, 0, 0, 156, 0, 94, 0, 79, 0, 73, 0, 76, 0, 116, 0, 45, 0, 37, 0, 32, 0, 10, 0, 126, 0, 252, 0, 9, 0, 98, 0, 102, 0, 68, 0, 218, 0, 203, 0, 206, 0, 37, 0, 231, 0, 169, 0, 0, 0, 4, 0, 156, 0, 144, 0, 0, 0, 77, 0, 82, 0, 108, 0, 127, 0, 241, 0, 24, 0, 184, 0, 194, 0, 44, 0, 243, 0, 156, 0, 215, 0, 42, 0, 0, 0, 250, 0, 126, 0, 0, 0, 223, 0, 255, 0, 85, 0, 25, 0, 7, 0, 134, 0, 9, 0, 67, 0, 246, 0, 9, 0, 0, 0, 203, 0, 235, 0, 153, 0, 249, 0, 103, 0, 63, 0, 124, 0, 98, 0, 212, 0, 235, 0, 40, 0, 163, 0, 243, 0, 94, 0, 216, 0, 185, 0, 238, 0, 192, 0, 150, 0, 0, 0, 171, 0, 160, 0, 112, 0, 248, 0, 23, 0, 0, 0, 159, 0, 136, 0, 173, 0, 0, 0, 240, 0, 225, 0, 63, 0, 97, 0, 171, 0, 253, 0, 24, 0, 122, 0, 0, 0, 63, 0, 32, 0, 174, 0, 0, 0, 6, 0, 174, 0, 0, 0, 38, 0, 160, 0, 254, 0, 49, 0, 60, 0, 49, 0, 191, 0, 7, 0, 248, 0, 122, 0, 182, 0, 60, 0, 188, 0, 211, 0, 46, 0, 60, 0, 130, 0, 207, 0, 91, 0, 172, 0, 216, 0, 104, 0, 146, 0, 0, 0, 54, 0, 210, 0, 32, 0, 241, 0, 230, 0, 54, 0, 229, 0, 0, 0, 0, 0, 135, 0, 150, 0, 0, 0, 253, 0, 127, 0, 230, 0);
    signal scenario_full_2  : scenario_type_2 := (39, 31, 39, 30, 39, 29, 74, 31, 80, 31, 50, 31, 74, 31, 74, 30, 74, 29, 20, 31, 188, 31, 33, 31, 33, 30, 221, 31, 130, 31, 175, 31, 186, 31, 186, 30, 44, 31, 184, 31, 104, 31, 1, 31, 228, 31, 158, 31, 51, 31, 122, 31, 163, 31, 163, 30, 216, 31, 159, 31, 192, 31, 192, 30, 48, 31, 48, 30, 48, 29, 162, 31, 162, 30, 238, 31, 7, 31, 7, 30, 67, 31, 67, 30, 9, 31, 9, 30, 129, 31, 207, 31, 37, 31, 208, 31, 240, 31, 240, 30, 180, 31, 180, 30, 101, 31, 101, 30, 25, 31, 192, 31, 171, 31, 171, 30, 47, 31, 39, 31, 25, 31, 25, 30, 77, 31, 91, 31, 104, 31, 25, 31, 186, 31, 70, 31, 155, 31, 54, 31, 176, 31, 255, 31, 62, 31, 62, 30, 40, 31, 177, 31, 144, 31, 214, 31, 1, 31, 213, 31, 139, 31, 138, 31, 134, 31, 57, 31, 176, 31, 45, 31, 113, 31, 191, 31, 231, 31, 35, 31, 35, 30, 35, 29, 128, 31, 128, 30, 105, 31, 85, 31, 159, 31, 159, 31, 68, 31, 193, 31, 69, 31, 6, 31, 119, 31, 191, 31, 191, 30, 91, 31, 154, 31, 240, 31, 233, 31, 233, 30, 55, 31, 31, 31, 78, 31, 31, 31, 17, 31, 224, 31, 30, 31, 6, 31, 6, 30, 41, 31, 60, 31, 60, 30, 85, 31, 135, 31, 135, 30, 181, 31, 218, 31, 195, 31, 158, 31, 158, 30, 158, 29, 251, 31, 251, 30, 170, 31, 127, 31, 206, 31, 249, 31, 61, 31, 61, 30, 161, 31, 110, 31, 110, 30, 110, 29, 141, 31, 142, 31, 96, 31, 62, 31, 242, 31, 169, 31, 79, 31, 238, 31, 28, 31, 90, 31, 44, 31, 148, 31, 30, 31, 207, 31, 207, 30, 207, 29, 207, 28, 11, 31, 94, 31, 104, 31, 104, 30, 109, 31, 109, 30, 220, 31, 174, 31, 132, 31, 98, 31, 117, 31, 252, 31, 128, 31, 51, 31, 198, 31, 198, 30, 69, 31, 44, 31, 44, 30, 25, 31, 61, 31, 61, 30, 61, 29, 239, 31, 133, 31, 204, 31, 202, 31, 171, 31, 171, 30, 63, 31, 79, 31, 79, 30, 25, 31, 244, 31, 199, 31, 35, 31, 37, 31, 139, 31, 51, 31, 188, 31, 230, 31, 23, 31, 23, 30, 102, 31, 124, 31, 127, 31, 174, 31, 184, 31, 184, 30, 92, 31, 187, 31, 187, 30, 177, 31, 134, 31, 126, 31, 126, 30, 146, 31, 146, 30, 27, 31, 44, 31, 187, 31, 167, 31, 167, 30, 105, 31, 180, 31, 192, 31, 137, 31, 42, 31, 200, 31, 101, 31, 210, 31, 210, 30, 172, 31, 100, 31, 202, 31, 202, 30, 215, 31, 177, 31, 177, 30, 177, 29, 229, 31, 25, 31, 222, 31, 69, 31, 225, 31, 225, 30, 51, 31, 167, 31, 119, 31, 119, 30, 203, 31, 28, 31, 28, 30, 27, 31, 204, 31, 107, 31, 56, 31, 236, 31, 129, 31, 221, 31, 224, 31, 8, 31, 8, 30, 228, 31, 14, 31, 43, 31, 109, 31, 54, 31, 210, 31, 16, 31, 18, 31, 18, 30, 156, 31, 94, 31, 79, 31, 73, 31, 76, 31, 116, 31, 45, 31, 37, 31, 32, 31, 10, 31, 126, 31, 252, 31, 9, 31, 98, 31, 102, 31, 68, 31, 218, 31, 203, 31, 206, 31, 37, 31, 231, 31, 169, 31, 169, 30, 4, 31, 156, 31, 144, 31, 144, 30, 77, 31, 82, 31, 108, 31, 127, 31, 241, 31, 24, 31, 184, 31, 194, 31, 44, 31, 243, 31, 156, 31, 215, 31, 42, 31, 42, 30, 250, 31, 126, 31, 126, 30, 223, 31, 255, 31, 85, 31, 25, 31, 7, 31, 134, 31, 9, 31, 67, 31, 246, 31, 9, 31, 9, 30, 203, 31, 235, 31, 153, 31, 249, 31, 103, 31, 63, 31, 124, 31, 98, 31, 212, 31, 235, 31, 40, 31, 163, 31, 243, 31, 94, 31, 216, 31, 185, 31, 238, 31, 192, 31, 150, 31, 150, 30, 171, 31, 160, 31, 112, 31, 248, 31, 23, 31, 23, 30, 159, 31, 136, 31, 173, 31, 173, 30, 240, 31, 225, 31, 63, 31, 97, 31, 171, 31, 253, 31, 24, 31, 122, 31, 122, 30, 63, 31, 32, 31, 174, 31, 174, 30, 6, 31, 174, 31, 174, 30, 38, 31, 160, 31, 254, 31, 49, 31, 60, 31, 49, 31, 191, 31, 7, 31, 248, 31, 122, 31, 182, 31, 60, 31, 188, 31, 211, 31, 46, 31, 60, 31, 130, 31, 207, 31, 91, 31, 172, 31, 216, 31, 104, 31, 146, 31, 146, 30, 54, 31, 210, 31, 32, 31, 241, 31, 230, 31, 54, 31, 229, 31, 229, 30, 229, 29, 135, 31, 150, 31, 150, 30, 253, 31, 127, 31, 230, 31);
    
    constant SCENARIO_ADDRESS_2 : integer := 40111;
    
    signal memory_control : std_logic := '0';

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH_1*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_1+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input_1(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_1, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH_1, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        --------------------------------------------------------------------------- start of second test
       
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH_2*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input_2(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH_2, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        -- test first input
        for i in 0 to SCENARIO_LENGTH_1*2-1 loop
            assert RAM(SCENARIO_ADDRESS_1+i) = std_logic_vector(to_unsigned(scenario_full_1(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full_1(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;
        
        -- test second input
        for i in 0 to SCENARIO_LENGTH_2*2-1 loop
            assert RAM(SCENARIO_ADDRESS_2+i) = std_logic_vector(to_unsigned(scenario_full_2(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full_2(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
