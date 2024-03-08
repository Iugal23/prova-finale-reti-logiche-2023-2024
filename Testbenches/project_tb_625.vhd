-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_625 is
end project_tb_625;

architecture project_tb_arch_625 of project_tb_625 is
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

constant SCENARIO_LENGTH : integer := 349;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (2,0,141,0,222,0,19,0,193,0,127,0,206,0,251,0,0,0,3,0,61,0,26,0,0,0,35,0,0,0,167,0,35,0,162,0,217,0,205,0,191,0,0,0,109,0,87,0,0,0,244,0,213,0,144,0,199,0,216,0,0,0,172,0,115,0,11,0,0,0,7,0,19,0,54,0,85,0,0,0,155,0,200,0,14,0,183,0,105,0,0,0,0,0,83,0,0,0,35,0,59,0,146,0,204,0,222,0,2,0,204,0,127,0,229,0,120,0,53,0,5,0,164,0,62,0,0,0,43,0,0,0,43,0,215,0,168,0,95,0,237,0,0,0,104,0,154,0,0,0,250,0,148,0,170,0,0,0,46,0,57,0,136,0,183,0,0,0,152,0,120,0,220,0,229,0,31,0,0,0,106,0,0,0,192,0,210,0,109,0,222,0,122,0,177,0,165,0,231,0,47,0,0,0,147,0,72,0,146,0,158,0,0,0,239,0,254,0,91,0,142,0,0,0,72,0,165,0,112,0,31,0,226,0,76,0,131,0,67,0,116,0,97,0,188,0,19,0,157,0,252,0,194,0,96,0,0,0,0,0,63,0,0,0,147,0,26,0,159,0,231,0,40,0,132,0,188,0,60,0,0,0,233,0,54,0,0,0,231,0,0,0,0,0,126,0,0,0,0,0,130,0,137,0,0,0,220,0,0,0,13,0,0,0,185,0,0,0,219,0,67,0,12,0,224,0,173,0,170,0,210,0,75,0,190,0,232,0,42,0,42,0,213,0,208,0,96,0,0,0,198,0,226,0,92,0,102,0,0,0,0,0,179,0,133,0,255,0,13,0,0,0,40,0,70,0,0,0,0,0,193,0,30,0,225,0,204,0,49,0,0,0,0,0,228,0,0,0,59,0,0,0,135,0,246,0,184,0,0,0,153,0,0,0,151,0,158,0,149,0,18,0,186,0,144,0,169,0,73,0,172,0,253,0,92,0,0,0,8,0,184,0,201,0,186,0,245,0,94,0,0,0,54,0,55,0,148,0,91,0,207,0,78,0,52,0,0,0,126,0,0,0,45,0,180,0,0,0,0,0,0,0,0,0,98,0,57,0,91,0,0,0,74,0,17,0,114,0,56,0,147,0,0,0,207,0,0,0,208,0,52,0,137,0,179,0,0,0,0,0,36,0,45,0,34,0,9,0,38,0,82,0,197,0,249,0,120,0,64,0,34,0,158,0,0,0,52,0,197,0,13,0,144,0,48,0,62,0,45,0,59,0,32,0,0,0,176,0,172,0,113,0,13,0,164,0,0,0,151,0,0,0,110,0,67,0,96,0,60,0,0,0,0,0,239,0,189,0,156,0,21,0,253,0,97,0,0,0,61,0,0,0,138,0,104,0,35,0,170,0,70,0,149,0,214,0,0,0,90,0,194,0,20,0,0,0,157,0,90,0,0,0,1,0,82,0,190,0,0,0,100,0,35,0,118,0,176,0,99,0,6,0,34,0,95,0,27,0,17,0,109,0,191,0,113,0,128,0,147,0,236,0,0,0,13,0,42,0,112,0,190,0,157,0,78,0,54,0);
signal scenario_full  : scenario_type := (2,31,141,31,222,31,19,31,193,31,127,31,206,31,251,31,251,30,3,31,61,31,26,31,26,30,35,31,35,30,167,31,35,31,162,31,217,31,205,31,191,31,191,30,109,31,87,31,87,30,244,31,213,31,144,31,199,31,216,31,216,30,172,31,115,31,11,31,11,30,7,31,19,31,54,31,85,31,85,30,155,31,200,31,14,31,183,31,105,31,105,30,105,29,83,31,83,30,35,31,59,31,146,31,204,31,222,31,2,31,204,31,127,31,229,31,120,31,53,31,5,31,164,31,62,31,62,30,43,31,43,30,43,31,215,31,168,31,95,31,237,31,237,30,104,31,154,31,154,30,250,31,148,31,170,31,170,30,46,31,57,31,136,31,183,31,183,30,152,31,120,31,220,31,229,31,31,31,31,30,106,31,106,30,192,31,210,31,109,31,222,31,122,31,177,31,165,31,231,31,47,31,47,30,147,31,72,31,146,31,158,31,158,30,239,31,254,31,91,31,142,31,142,30,72,31,165,31,112,31,31,31,226,31,76,31,131,31,67,31,116,31,97,31,188,31,19,31,157,31,252,31,194,31,96,31,96,30,96,29,63,31,63,30,147,31,26,31,159,31,231,31,40,31,132,31,188,31,60,31,60,30,233,31,54,31,54,30,231,31,231,30,231,29,126,31,126,30,126,29,130,31,137,31,137,30,220,31,220,30,13,31,13,30,185,31,185,30,219,31,67,31,12,31,224,31,173,31,170,31,210,31,75,31,190,31,232,31,42,31,42,31,213,31,208,31,96,31,96,30,198,31,226,31,92,31,102,31,102,30,102,29,179,31,133,31,255,31,13,31,13,30,40,31,70,31,70,30,70,29,193,31,30,31,225,31,204,31,49,31,49,30,49,29,228,31,228,30,59,31,59,30,135,31,246,31,184,31,184,30,153,31,153,30,151,31,158,31,149,31,18,31,186,31,144,31,169,31,73,31,172,31,253,31,92,31,92,30,8,31,184,31,201,31,186,31,245,31,94,31,94,30,54,31,55,31,148,31,91,31,207,31,78,31,52,31,52,30,126,31,126,30,45,31,180,31,180,30,180,29,180,28,180,27,98,31,57,31,91,31,91,30,74,31,17,31,114,31,56,31,147,31,147,30,207,31,207,30,208,31,52,31,137,31,179,31,179,30,179,29,36,31,45,31,34,31,9,31,38,31,82,31,197,31,249,31,120,31,64,31,34,31,158,31,158,30,52,31,197,31,13,31,144,31,48,31,62,31,45,31,59,31,32,31,32,30,176,31,172,31,113,31,13,31,164,31,164,30,151,31,151,30,110,31,67,31,96,31,60,31,60,30,60,29,239,31,189,31,156,31,21,31,253,31,97,31,97,30,61,31,61,30,138,31,104,31,35,31,170,31,70,31,149,31,214,31,214,30,90,31,194,31,20,31,20,30,157,31,90,31,90,30,1,31,82,31,190,31,190,30,100,31,35,31,118,31,176,31,99,31,6,31,34,31,95,31,27,31,17,31,109,31,191,31,113,31,128,31,147,31,236,31,236,30,13,31,42,31,112,31,190,31,157,31,78,31,54,31);

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
