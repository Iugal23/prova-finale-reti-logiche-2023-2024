-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_421 is
end project_tb_421;

architecture project_tb_arch_421 of project_tb_421 is
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

constant SCENARIO_LENGTH : integer := 452;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (194,0,0,0,200,0,102,0,186,0,0,0,0,0,35,0,218,0,87,0,217,0,220,0,86,0,10,0,71,0,24,0,195,0,180,0,83,0,236,0,123,0,0,0,137,0,203,0,151,0,9,0,70,0,156,0,133,0,20,0,216,0,67,0,61,0,207,0,0,0,0,0,0,0,35,0,12,0,0,0,138,0,159,0,250,0,251,0,0,0,47,0,220,0,221,0,81,0,184,0,0,0,208,0,158,0,205,0,33,0,94,0,109,0,33,0,0,0,234,0,204,0,108,0,0,0,157,0,0,0,96,0,0,0,0,0,175,0,0,0,245,0,224,0,0,0,18,0,0,0,108,0,0,0,84,0,0,0,228,0,189,0,196,0,0,0,0,0,0,0,180,0,0,0,143,0,200,0,168,0,74,0,26,0,17,0,225,0,212,0,0,0,23,0,0,0,224,0,0,0,29,0,88,0,157,0,0,0,13,0,46,0,182,0,65,0,140,0,98,0,84,0,115,0,182,0,0,0,83,0,206,0,0,0,4,0,244,0,0,0,23,0,0,0,0,0,0,0,84,0,170,0,240,0,0,0,175,0,0,0,123,0,144,0,122,0,135,0,0,0,98,0,0,0,172,0,209,0,0,0,109,0,224,0,172,0,0,0,203,0,221,0,211,0,232,0,208,0,0,0,186,0,181,0,72,0,34,0,58,0,64,0,18,0,104,0,137,0,217,0,223,0,219,0,0,0,44,0,5,0,127,0,0,0,180,0,111,0,129,0,174,0,29,0,141,0,0,0,202,0,45,0,5,0,58,0,123,0,133,0,0,0,0,0,48,0,0,0,0,0,205,0,27,0,71,0,243,0,232,0,210,0,198,0,102,0,143,0,153,0,0,0,188,0,153,0,95,0,60,0,241,0,0,0,0,0,17,0,0,0,192,0,212,0,128,0,0,0,91,0,193,0,68,0,47,0,240,0,0,0,140,0,109,0,0,0,216,0,71,0,237,0,190,0,12,0,50,0,154,0,166,0,103,0,0,0,0,0,10,0,204,0,186,0,158,0,34,0,7,0,196,0,0,0,22,0,178,0,0,0,81,0,2,0,123,0,207,0,226,0,173,0,131,0,0,0,169,0,188,0,114,0,245,0,243,0,5,0,51,0,0,0,171,0,147,0,71,0,209,0,8,0,0,0,8,0,56,0,33,0,104,0,0,0,215,0,60,0,39,0,192,0,0,0,255,0,0,0,0,0,2,0,190,0,177,0,33,0,185,0,68,0,47,0,151,0,192,0,0,0,226,0,80,0,129,0,233,0,51,0,87,0,84,0,26,0,133,0,0,0,84,0,0,0,202,0,188,0,255,0,249,0,0,0,0,0,207,0,12,0,88,0,85,0,68,0,0,0,17,0,0,0,238,0,0,0,120,0,0,0,0,0,254,0,130,0,96,0,16,0,162,0,0,0,216,0,0,0,222,0,76,0,203,0,91,0,15,0,0,0,2,0,0,0,175,0,67,0,233,0,11,0,64,0,78,0,71,0,243,0,0,0,78,0,44,0,82,0,215,0,186,0,105,0,147,0,0,0,0,0,5,0,55,0,198,0,24,0,224,0,186,0,248,0,205,0,145,0,160,0,124,0,196,0,26,0,209,0,110,0,128,0,168,0,0,0,145,0,154,0,193,0,9,0,52,0,107,0,183,0,169,0,171,0,194,0,97,0,154,0,90,0,0,0,96,0,7,0,72,0,182,0,183,0,37,0,210,0,172,0,69,0,109,0,224,0,13,0,0,0,147,0,111,0,154,0,107,0,114,0,232,0,236,0,77,0,0,0,0,0,77,0,153,0,0,0,86,0,0,0,0,0,16,0,0,0,78,0,36,0,68,0,93,0,78,0,144,0,31,0,225,0,103,0,20,0,179,0,23,0,70,0,41,0,5,0,70,0,0,0,59,0,0,0,168,0,194,0,0,0,0,0,208,0,27,0,225,0,31,0,80,0,81,0,139,0,44,0,90,0,175,0,72,0,179,0,0,0,76,0,113,0,137,0);
signal scenario_full  : scenario_type := (194,31,194,30,200,31,102,31,186,31,186,30,186,29,35,31,218,31,87,31,217,31,220,31,86,31,10,31,71,31,24,31,195,31,180,31,83,31,236,31,123,31,123,30,137,31,203,31,151,31,9,31,70,31,156,31,133,31,20,31,216,31,67,31,61,31,207,31,207,30,207,29,207,28,35,31,12,31,12,30,138,31,159,31,250,31,251,31,251,30,47,31,220,31,221,31,81,31,184,31,184,30,208,31,158,31,205,31,33,31,94,31,109,31,33,31,33,30,234,31,204,31,108,31,108,30,157,31,157,30,96,31,96,30,96,29,175,31,175,30,245,31,224,31,224,30,18,31,18,30,108,31,108,30,84,31,84,30,228,31,189,31,196,31,196,30,196,29,196,28,180,31,180,30,143,31,200,31,168,31,74,31,26,31,17,31,225,31,212,31,212,30,23,31,23,30,224,31,224,30,29,31,88,31,157,31,157,30,13,31,46,31,182,31,65,31,140,31,98,31,84,31,115,31,182,31,182,30,83,31,206,31,206,30,4,31,244,31,244,30,23,31,23,30,23,29,23,28,84,31,170,31,240,31,240,30,175,31,175,30,123,31,144,31,122,31,135,31,135,30,98,31,98,30,172,31,209,31,209,30,109,31,224,31,172,31,172,30,203,31,221,31,211,31,232,31,208,31,208,30,186,31,181,31,72,31,34,31,58,31,64,31,18,31,104,31,137,31,217,31,223,31,219,31,219,30,44,31,5,31,127,31,127,30,180,31,111,31,129,31,174,31,29,31,141,31,141,30,202,31,45,31,5,31,58,31,123,31,133,31,133,30,133,29,48,31,48,30,48,29,205,31,27,31,71,31,243,31,232,31,210,31,198,31,102,31,143,31,153,31,153,30,188,31,153,31,95,31,60,31,241,31,241,30,241,29,17,31,17,30,192,31,212,31,128,31,128,30,91,31,193,31,68,31,47,31,240,31,240,30,140,31,109,31,109,30,216,31,71,31,237,31,190,31,12,31,50,31,154,31,166,31,103,31,103,30,103,29,10,31,204,31,186,31,158,31,34,31,7,31,196,31,196,30,22,31,178,31,178,30,81,31,2,31,123,31,207,31,226,31,173,31,131,31,131,30,169,31,188,31,114,31,245,31,243,31,5,31,51,31,51,30,171,31,147,31,71,31,209,31,8,31,8,30,8,31,56,31,33,31,104,31,104,30,215,31,60,31,39,31,192,31,192,30,255,31,255,30,255,29,2,31,190,31,177,31,33,31,185,31,68,31,47,31,151,31,192,31,192,30,226,31,80,31,129,31,233,31,51,31,87,31,84,31,26,31,133,31,133,30,84,31,84,30,202,31,188,31,255,31,249,31,249,30,249,29,207,31,12,31,88,31,85,31,68,31,68,30,17,31,17,30,238,31,238,30,120,31,120,30,120,29,254,31,130,31,96,31,16,31,162,31,162,30,216,31,216,30,222,31,76,31,203,31,91,31,15,31,15,30,2,31,2,30,175,31,67,31,233,31,11,31,64,31,78,31,71,31,243,31,243,30,78,31,44,31,82,31,215,31,186,31,105,31,147,31,147,30,147,29,5,31,55,31,198,31,24,31,224,31,186,31,248,31,205,31,145,31,160,31,124,31,196,31,26,31,209,31,110,31,128,31,168,31,168,30,145,31,154,31,193,31,9,31,52,31,107,31,183,31,169,31,171,31,194,31,97,31,154,31,90,31,90,30,96,31,7,31,72,31,182,31,183,31,37,31,210,31,172,31,69,31,109,31,224,31,13,31,13,30,147,31,111,31,154,31,107,31,114,31,232,31,236,31,77,31,77,30,77,29,77,31,153,31,153,30,86,31,86,30,86,29,16,31,16,30,78,31,36,31,68,31,93,31,78,31,144,31,31,31,225,31,103,31,20,31,179,31,23,31,70,31,41,31,5,31,70,31,70,30,59,31,59,30,168,31,194,31,194,30,194,29,208,31,27,31,225,31,31,31,80,31,81,31,139,31,44,31,90,31,175,31,72,31,179,31,179,30,76,31,113,31,137,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

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
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
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

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
