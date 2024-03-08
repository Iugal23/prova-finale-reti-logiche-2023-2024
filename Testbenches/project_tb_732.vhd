-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_732 is
end project_tb_732;

architecture project_tb_arch_732 of project_tb_732 is
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

constant SCENARIO_LENGTH : integer := 422;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (189,0,80,0,58,0,236,0,0,0,88,0,97,0,101,0,102,0,114,0,0,0,67,0,52,0,42,0,90,0,0,0,0,0,21,0,67,0,196,0,201,0,171,0,137,0,148,0,45,0,83,0,252,0,38,0,29,0,0,0,180,0,0,0,24,0,62,0,42,0,0,0,6,0,75,0,36,0,45,0,6,0,83,0,156,0,29,0,125,0,0,0,0,0,148,0,199,0,0,0,131,0,149,0,137,0,80,0,49,0,26,0,201,0,203,0,0,0,0,0,13,0,226,0,0,0,190,0,91,0,93,0,237,0,177,0,0,0,220,0,7,0,40,0,21,0,182,0,79,0,0,0,26,0,33,0,59,0,60,0,188,0,254,0,133,0,0,0,60,0,169,0,92,0,76,0,46,0,11,0,0,0,53,0,226,0,221,0,86,0,124,0,190,0,21,0,0,0,214,0,107,0,66,0,106,0,0,0,173,0,0,0,192,0,130,0,186,0,0,0,10,0,187,0,145,0,167,0,162,0,191,0,181,0,21,0,95,0,57,0,76,0,112,0,37,0,66,0,83,0,149,0,43,0,124,0,185,0,105,0,63,0,139,0,86,0,217,0,0,0,94,0,123,0,134,0,224,0,208,0,192,0,118,0,0,0,229,0,144,0,117,0,47,0,233,0,182,0,184,0,31,0,0,0,6,0,179,0,53,0,57,0,156,0,43,0,0,0,90,0,86,0,173,0,235,0,130,0,62,0,104,0,129,0,22,0,168,0,243,0,41,0,158,0,183,0,57,0,0,0,54,0,86,0,216,0,9,0,208,0,72,0,89,0,214,0,47,0,0,0,71,0,0,0,107,0,42,0,143,0,133,0,59,0,94,0,12,0,179,0,230,0,64,0,81,0,167,0,61,0,178,0,46,0,236,0,85,0,0,0,0,0,152,0,68,0,140,0,0,0,225,0,127,0,233,0,234,0,136,0,115,0,0,0,26,0,234,0,0,0,211,0,113,0,0,0,175,0,0,0,54,0,0,0,48,0,0,0,185,0,190,0,0,0,122,0,29,0,17,0,140,0,63,0,241,0,185,0,64,0,58,0,58,0,70,0,11,0,252,0,96,0,0,0,226,0,32,0,40,0,200,0,64,0,151,0,75,0,38,0,160,0,230,0,168,0,0,0,196,0,221,0,184,0,121,0,11,0,0,0,56,0,202,0,0,0,247,0,68,0,171,0,197,0,75,0,0,0,0,0,0,0,0,0,80,0,56,0,164,0,147,0,191,0,181,0,0,0,13,0,181,0,255,0,174,0,213,0,81,0,254,0,241,0,155,0,136,0,157,0,158,0,185,0,0,0,63,0,98,0,51,0,194,0,134,0,34,0,248,0,154,0,82,0,110,0,0,0,39,0,248,0,224,0,162,0,76,0,226,0,0,0,0,0,252,0,174,0,171,0,169,0,143,0,101,0,72,0,66,0,31,0,232,0,60,0,22,0,81,0,22,0,253,0,57,0,50,0,35,0,183,0,0,0,54,0,65,0,232,0,201,0,148,0,11,0,4,0,13,0,74,0,41,0,0,0,165,0,132,0,231,0,16,0,120,0,0,0,48,0,215,0,149,0,201,0,48,0,0,0,221,0,228,0,165,0,0,0,73,0,155,0,149,0,81,0,139,0,50,0,0,0,221,0,53,0,155,0,83,0,22,0,193,0,196,0,116,0,213,0,168,0,225,0,242,0,58,0,98,0,54,0,37,0,207,0,0,0,64,0,145,0,110,0,128,0,208,0,0,0,222,0,78,0,0,0,0,0,225,0,82,0,0,0,0,0,182,0,146,0,134,0,221,0,201,0,43,0,0,0,252,0,253,0,121,0,203,0,114,0,0,0,91,0,0,0,128,0,214,0,0,0,0,0);
signal scenario_full  : scenario_type := (189,31,80,31,58,31,236,31,236,30,88,31,97,31,101,31,102,31,114,31,114,30,67,31,52,31,42,31,90,31,90,30,90,29,21,31,67,31,196,31,201,31,171,31,137,31,148,31,45,31,83,31,252,31,38,31,29,31,29,30,180,31,180,30,24,31,62,31,42,31,42,30,6,31,75,31,36,31,45,31,6,31,83,31,156,31,29,31,125,31,125,30,125,29,148,31,199,31,199,30,131,31,149,31,137,31,80,31,49,31,26,31,201,31,203,31,203,30,203,29,13,31,226,31,226,30,190,31,91,31,93,31,237,31,177,31,177,30,220,31,7,31,40,31,21,31,182,31,79,31,79,30,26,31,33,31,59,31,60,31,188,31,254,31,133,31,133,30,60,31,169,31,92,31,76,31,46,31,11,31,11,30,53,31,226,31,221,31,86,31,124,31,190,31,21,31,21,30,214,31,107,31,66,31,106,31,106,30,173,31,173,30,192,31,130,31,186,31,186,30,10,31,187,31,145,31,167,31,162,31,191,31,181,31,21,31,95,31,57,31,76,31,112,31,37,31,66,31,83,31,149,31,43,31,124,31,185,31,105,31,63,31,139,31,86,31,217,31,217,30,94,31,123,31,134,31,224,31,208,31,192,31,118,31,118,30,229,31,144,31,117,31,47,31,233,31,182,31,184,31,31,31,31,30,6,31,179,31,53,31,57,31,156,31,43,31,43,30,90,31,86,31,173,31,235,31,130,31,62,31,104,31,129,31,22,31,168,31,243,31,41,31,158,31,183,31,57,31,57,30,54,31,86,31,216,31,9,31,208,31,72,31,89,31,214,31,47,31,47,30,71,31,71,30,107,31,42,31,143,31,133,31,59,31,94,31,12,31,179,31,230,31,64,31,81,31,167,31,61,31,178,31,46,31,236,31,85,31,85,30,85,29,152,31,68,31,140,31,140,30,225,31,127,31,233,31,234,31,136,31,115,31,115,30,26,31,234,31,234,30,211,31,113,31,113,30,175,31,175,30,54,31,54,30,48,31,48,30,185,31,190,31,190,30,122,31,29,31,17,31,140,31,63,31,241,31,185,31,64,31,58,31,58,31,70,31,11,31,252,31,96,31,96,30,226,31,32,31,40,31,200,31,64,31,151,31,75,31,38,31,160,31,230,31,168,31,168,30,196,31,221,31,184,31,121,31,11,31,11,30,56,31,202,31,202,30,247,31,68,31,171,31,197,31,75,31,75,30,75,29,75,28,75,27,80,31,56,31,164,31,147,31,191,31,181,31,181,30,13,31,181,31,255,31,174,31,213,31,81,31,254,31,241,31,155,31,136,31,157,31,158,31,185,31,185,30,63,31,98,31,51,31,194,31,134,31,34,31,248,31,154,31,82,31,110,31,110,30,39,31,248,31,224,31,162,31,76,31,226,31,226,30,226,29,252,31,174,31,171,31,169,31,143,31,101,31,72,31,66,31,31,31,232,31,60,31,22,31,81,31,22,31,253,31,57,31,50,31,35,31,183,31,183,30,54,31,65,31,232,31,201,31,148,31,11,31,4,31,13,31,74,31,41,31,41,30,165,31,132,31,231,31,16,31,120,31,120,30,48,31,215,31,149,31,201,31,48,31,48,30,221,31,228,31,165,31,165,30,73,31,155,31,149,31,81,31,139,31,50,31,50,30,221,31,53,31,155,31,83,31,22,31,193,31,196,31,116,31,213,31,168,31,225,31,242,31,58,31,98,31,54,31,37,31,207,31,207,30,64,31,145,31,110,31,128,31,208,31,208,30,222,31,78,31,78,30,78,29,225,31,82,31,82,30,82,29,182,31,146,31,134,31,221,31,201,31,43,31,43,30,252,31,253,31,121,31,203,31,114,31,114,30,91,31,91,30,128,31,214,31,214,30,214,29);

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
