-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_619 is
end project_tb_619;

architecture project_tb_arch_619 of project_tb_619 is
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

constant SCENARIO_LENGTH : integer := 419;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,85,0,85,0,230,0,209,0,72,0,0,0,0,0,46,0,218,0,251,0,0,0,73,0,8,0,47,0,179,0,206,0,170,0,97,0,184,0,0,0,0,0,146,0,247,0,181,0,0,0,13,0,0,0,216,0,0,0,170,0,154,0,11,0,0,0,130,0,143,0,108,0,89,0,246,0,46,0,0,0,134,0,139,0,160,0,0,0,130,0,231,0,103,0,28,0,168,0,193,0,0,0,186,0,203,0,0,0,0,0,27,0,3,0,119,0,23,0,0,0,103,0,72,0,228,0,164,0,194,0,220,0,254,0,71,0,0,0,170,0,135,0,205,0,84,0,84,0,238,0,105,0,38,0,187,0,230,0,83,0,0,0,0,0,110,0,0,0,0,0,19,0,61,0,123,0,228,0,161,0,72,0,186,0,228,0,68,0,22,0,27,0,202,0,178,0,55,0,144,0,46,0,148,0,219,0,39,0,130,0,61,0,157,0,0,0,101,0,107,0,211,0,11,0,98,0,213,0,22,0,9,0,180,0,0,0,213,0,192,0,0,0,86,0,142,0,165,0,249,0,240,0,131,0,0,0,141,0,223,0,0,0,17,0,54,0,61,0,2,0,64,0,73,0,202,0,0,0,10,0,56,0,247,0,95,0,151,0,0,0,80,0,84,0,19,0,0,0,0,0,0,0,206,0,52,0,51,0,0,0,164,0,120,0,197,0,137,0,0,0,96,0,103,0,166,0,150,0,114,0,155,0,247,0,0,0,135,0,214,0,190,0,98,0,15,0,63,0,166,0,83,0,99,0,156,0,0,0,165,0,17,0,227,0,0,0,182,0,100,0,107,0,140,0,2,0,14,0,210,0,0,0,85,0,113,0,108,0,176,0,0,0,185,0,0,0,161,0,234,0,155,0,56,0,215,0,0,0,0,0,4,0,152,0,0,0,246,0,222,0,153,0,134,0,0,0,43,0,138,0,0,0,166,0,0,0,26,0,127,0,81,0,107,0,17,0,0,0,0,0,233,0,0,0,68,0,0,0,0,0,20,0,16,0,0,0,135,0,33,0,61,0,160,0,218,0,204,0,203,0,183,0,0,0,28,0,194,0,105,0,0,0,110,0,54,0,38,0,70,0,58,0,0,0,102,0,231,0,98,0,63,0,137,0,161,0,57,0,215,0,99,0,254,0,69,0,134,0,101,0,224,0,8,0,207,0,22,0,250,0,120,0,0,0,23,0,251,0,18,0,43,0,0,0,15,0,236,0,241,0,0,0,0,0,87,0,12,0,57,0,174,0,173,0,33,0,228,0,240,0,162,0,162,0,94,0,197,0,0,0,202,0,233,0,156,0,156,0,143,0,162,0,0,0,73,0,0,0,0,0,111,0,185,0,0,0,173,0,55,0,31,0,0,0,158,0,116,0,236,0,0,0,206,0,10,0,48,0,31,0,0,0,79,0,50,0,65,0,0,0,49,0,0,0,86,0,89,0,0,0,5,0,228,0,124,0,172,0,111,0,51,0,4,0,200,0,241,0,170,0,186,0,1,0,0,0,0,0,32,0,51,0,35,0,62,0,149,0,0,0,198,0,217,0,151,0,125,0,17,0,119,0,180,0,248,0,157,0,62,0,39,0,172,0,0,0,0,0,76,0,234,0,16,0,0,0,19,0,114,0,112,0,7,0,179,0,0,0,11,0,9,0,0,0,172,0,248,0,8,0,78,0,0,0,112,0,30,0,0,0,68,0,19,0,93,0,36,0,64,0,218,0,61,0,0,0,103,0,193,0,175,0,0,0,0,0,19,0,115,0,103,0,116,0,133,0,144,0,224,0,0,0,153,0,118,0,235,0,0,0,75,0,134,0,79,0,0,0,97,0,23,0,186,0,205,0);
signal scenario_full  : scenario_type := (0,0,85,31,85,31,230,31,209,31,72,31,72,30,72,29,46,31,218,31,251,31,251,30,73,31,8,31,47,31,179,31,206,31,170,31,97,31,184,31,184,30,184,29,146,31,247,31,181,31,181,30,13,31,13,30,216,31,216,30,170,31,154,31,11,31,11,30,130,31,143,31,108,31,89,31,246,31,46,31,46,30,134,31,139,31,160,31,160,30,130,31,231,31,103,31,28,31,168,31,193,31,193,30,186,31,203,31,203,30,203,29,27,31,3,31,119,31,23,31,23,30,103,31,72,31,228,31,164,31,194,31,220,31,254,31,71,31,71,30,170,31,135,31,205,31,84,31,84,31,238,31,105,31,38,31,187,31,230,31,83,31,83,30,83,29,110,31,110,30,110,29,19,31,61,31,123,31,228,31,161,31,72,31,186,31,228,31,68,31,22,31,27,31,202,31,178,31,55,31,144,31,46,31,148,31,219,31,39,31,130,31,61,31,157,31,157,30,101,31,107,31,211,31,11,31,98,31,213,31,22,31,9,31,180,31,180,30,213,31,192,31,192,30,86,31,142,31,165,31,249,31,240,31,131,31,131,30,141,31,223,31,223,30,17,31,54,31,61,31,2,31,64,31,73,31,202,31,202,30,10,31,56,31,247,31,95,31,151,31,151,30,80,31,84,31,19,31,19,30,19,29,19,28,206,31,52,31,51,31,51,30,164,31,120,31,197,31,137,31,137,30,96,31,103,31,166,31,150,31,114,31,155,31,247,31,247,30,135,31,214,31,190,31,98,31,15,31,63,31,166,31,83,31,99,31,156,31,156,30,165,31,17,31,227,31,227,30,182,31,100,31,107,31,140,31,2,31,14,31,210,31,210,30,85,31,113,31,108,31,176,31,176,30,185,31,185,30,161,31,234,31,155,31,56,31,215,31,215,30,215,29,4,31,152,31,152,30,246,31,222,31,153,31,134,31,134,30,43,31,138,31,138,30,166,31,166,30,26,31,127,31,81,31,107,31,17,31,17,30,17,29,233,31,233,30,68,31,68,30,68,29,20,31,16,31,16,30,135,31,33,31,61,31,160,31,218,31,204,31,203,31,183,31,183,30,28,31,194,31,105,31,105,30,110,31,54,31,38,31,70,31,58,31,58,30,102,31,231,31,98,31,63,31,137,31,161,31,57,31,215,31,99,31,254,31,69,31,134,31,101,31,224,31,8,31,207,31,22,31,250,31,120,31,120,30,23,31,251,31,18,31,43,31,43,30,15,31,236,31,241,31,241,30,241,29,87,31,12,31,57,31,174,31,173,31,33,31,228,31,240,31,162,31,162,31,94,31,197,31,197,30,202,31,233,31,156,31,156,31,143,31,162,31,162,30,73,31,73,30,73,29,111,31,185,31,185,30,173,31,55,31,31,31,31,30,158,31,116,31,236,31,236,30,206,31,10,31,48,31,31,31,31,30,79,31,50,31,65,31,65,30,49,31,49,30,86,31,89,31,89,30,5,31,228,31,124,31,172,31,111,31,51,31,4,31,200,31,241,31,170,31,186,31,1,31,1,30,1,29,32,31,51,31,35,31,62,31,149,31,149,30,198,31,217,31,151,31,125,31,17,31,119,31,180,31,248,31,157,31,62,31,39,31,172,31,172,30,172,29,76,31,234,31,16,31,16,30,19,31,114,31,112,31,7,31,179,31,179,30,11,31,9,31,9,30,172,31,248,31,8,31,78,31,78,30,112,31,30,31,30,30,68,31,19,31,93,31,36,31,64,31,218,31,61,31,61,30,103,31,193,31,175,31,175,30,175,29,19,31,115,31,103,31,116,31,133,31,144,31,224,31,224,30,153,31,118,31,235,31,235,30,75,31,134,31,79,31,79,30,97,31,23,31,186,31,205,31);

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
