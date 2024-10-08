-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_964 is
end project_tb_964;

architecture project_tb_arch_964 of project_tb_964 is
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

constant SCENARIO_LENGTH : integer := 335;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (44,0,248,0,0,0,0,0,0,0,185,0,43,0,123,0,120,0,66,0,0,0,209,0,131,0,0,0,0,0,0,0,3,0,121,0,137,0,0,0,0,0,108,0,75,0,37,0,197,0,168,0,99,0,25,0,146,0,102,0,0,0,56,0,172,0,184,0,0,0,0,0,197,0,0,0,233,0,223,0,0,0,60,0,168,0,130,0,57,0,224,0,190,0,0,0,0,0,158,0,0,0,0,0,0,0,63,0,181,0,11,0,100,0,223,0,190,0,0,0,74,0,0,0,240,0,0,0,0,0,157,0,135,0,123,0,0,0,228,0,132,0,46,0,117,0,215,0,44,0,0,0,110,0,195,0,69,0,194,0,202,0,79,0,149,0,0,0,25,0,100,0,134,0,0,0,163,0,47,0,204,0,123,0,18,0,119,0,107,0,89,0,172,0,0,0,93,0,119,0,38,0,242,0,201,0,159,0,0,0,152,0,216,0,200,0,11,0,171,0,187,0,222,0,165,0,79,0,177,0,2,0,255,0,151,0,186,0,94,0,215,0,202,0,232,0,138,0,36,0,222,0,68,0,5,0,75,0,60,0,0,0,83,0,220,0,0,0,0,0,141,0,193,0,92,0,80,0,238,0,19,0,163,0,0,0,135,0,93,0,10,0,7,0,0,0,182,0,244,0,0,0,186,0,79,0,73,0,33,0,247,0,201,0,145,0,8,0,244,0,167,0,5,0,216,0,0,0,196,0,157,0,213,0,139,0,0,0,84,0,79,0,234,0,13,0,0,0,236,0,88,0,108,0,169,0,253,0,0,0,37,0,226,0,30,0,217,0,171,0,118,0,2,0,126,0,127,0,160,0,0,0,133,0,253,0,70,0,157,0,120,0,175,0,184,0,0,0,101,0,175,0,135,0,113,0,157,0,176,0,45,0,0,0,144,0,0,0,22,0,81,0,25,0,225,0,122,0,5,0,183,0,161,0,248,0,96,0,0,0,22,0,14,0,0,0,84,0,0,0,0,0,0,0,186,0,218,0,0,0,15,0,230,0,163,0,92,0,127,0,75,0,178,0,254,0,26,0,146,0,50,0,138,0,176,0,106,0,225,0,212,0,0,0,69,0,76,0,46,0,0,0,44,0,127,0,228,0,237,0,0,0,86,0,215,0,0,0,96,0,165,0,116,0,191,0,16,0,194,0,13,0,14,0,199,0,0,0,0,0,68,0,64,0,137,0,248,0,108,0,244,0,0,0,211,0,160,0,18,0,0,0,0,0,138,0,204,0,189,0,9,0,80,0,158,0,47,0,17,0,47,0,0,0,62,0,127,0,192,0,130,0,125,0,172,0,162,0,248,0,197,0,0,0,229,0,0,0,227,0,95,0,0,0,115,0,0,0,242,0,0,0,3,0,34,0,129,0,4,0,30,0,135,0,102,0,254,0,24,0,84,0,100,0,179,0,3,0,0,0,0,0,93,0,205,0,0,0,0,0,229,0,152,0,225,0,181,0,178,0);
signal scenario_full  : scenario_type := (44,31,248,31,248,30,248,29,248,28,185,31,43,31,123,31,120,31,66,31,66,30,209,31,131,31,131,30,131,29,131,28,3,31,121,31,137,31,137,30,137,29,108,31,75,31,37,31,197,31,168,31,99,31,25,31,146,31,102,31,102,30,56,31,172,31,184,31,184,30,184,29,197,31,197,30,233,31,223,31,223,30,60,31,168,31,130,31,57,31,224,31,190,31,190,30,190,29,158,31,158,30,158,29,158,28,63,31,181,31,11,31,100,31,223,31,190,31,190,30,74,31,74,30,240,31,240,30,240,29,157,31,135,31,123,31,123,30,228,31,132,31,46,31,117,31,215,31,44,31,44,30,110,31,195,31,69,31,194,31,202,31,79,31,149,31,149,30,25,31,100,31,134,31,134,30,163,31,47,31,204,31,123,31,18,31,119,31,107,31,89,31,172,31,172,30,93,31,119,31,38,31,242,31,201,31,159,31,159,30,152,31,216,31,200,31,11,31,171,31,187,31,222,31,165,31,79,31,177,31,2,31,255,31,151,31,186,31,94,31,215,31,202,31,232,31,138,31,36,31,222,31,68,31,5,31,75,31,60,31,60,30,83,31,220,31,220,30,220,29,141,31,193,31,92,31,80,31,238,31,19,31,163,31,163,30,135,31,93,31,10,31,7,31,7,30,182,31,244,31,244,30,186,31,79,31,73,31,33,31,247,31,201,31,145,31,8,31,244,31,167,31,5,31,216,31,216,30,196,31,157,31,213,31,139,31,139,30,84,31,79,31,234,31,13,31,13,30,236,31,88,31,108,31,169,31,253,31,253,30,37,31,226,31,30,31,217,31,171,31,118,31,2,31,126,31,127,31,160,31,160,30,133,31,253,31,70,31,157,31,120,31,175,31,184,31,184,30,101,31,175,31,135,31,113,31,157,31,176,31,45,31,45,30,144,31,144,30,22,31,81,31,25,31,225,31,122,31,5,31,183,31,161,31,248,31,96,31,96,30,22,31,14,31,14,30,84,31,84,30,84,29,84,28,186,31,218,31,218,30,15,31,230,31,163,31,92,31,127,31,75,31,178,31,254,31,26,31,146,31,50,31,138,31,176,31,106,31,225,31,212,31,212,30,69,31,76,31,46,31,46,30,44,31,127,31,228,31,237,31,237,30,86,31,215,31,215,30,96,31,165,31,116,31,191,31,16,31,194,31,13,31,14,31,199,31,199,30,199,29,68,31,64,31,137,31,248,31,108,31,244,31,244,30,211,31,160,31,18,31,18,30,18,29,138,31,204,31,189,31,9,31,80,31,158,31,47,31,17,31,47,31,47,30,62,31,127,31,192,31,130,31,125,31,172,31,162,31,248,31,197,31,197,30,229,31,229,30,227,31,95,31,95,30,115,31,115,30,242,31,242,30,3,31,34,31,129,31,4,31,30,31,135,31,102,31,254,31,24,31,84,31,100,31,179,31,3,31,3,30,3,29,93,31,205,31,205,30,205,29,229,31,152,31,225,31,181,31,178,31);

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
