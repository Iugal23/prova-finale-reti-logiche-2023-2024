-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_611 is
end project_tb_611;

architecture project_tb_arch_611 of project_tb_611 is
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

constant SCENARIO_LENGTH : integer := 501;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,12,0,20,0,0,0,0,0,68,0,114,0,0,0,175,0,201,0,166,0,84,0,48,0,0,0,69,0,204,0,8,0,146,0,55,0,0,0,228,0,228,0,229,0,94,0,94,0,52,0,0,0,50,0,22,0,0,0,23,0,169,0,212,0,199,0,83,0,0,0,61,0,160,0,66,0,0,0,64,0,0,0,17,0,132,0,92,0,213,0,146,0,23,0,138,0,185,0,82,0,212,0,99,0,0,0,168,0,164,0,24,0,7,0,99,0,0,0,53,0,45,0,113,0,84,0,0,0,157,0,20,0,133,0,40,0,0,0,189,0,0,0,158,0,245,0,14,0,183,0,167,0,180,0,0,0,188,0,59,0,165,0,64,0,200,0,64,0,99,0,243,0,231,0,0,0,0,0,80,0,0,0,84,0,0,0,139,0,152,0,0,0,72,0,9,0,51,0,67,0,24,0,73,0,0,0,149,0,47,0,11,0,59,0,26,0,189,0,138,0,0,0,236,0,0,0,40,0,156,0,209,0,150,0,6,0,89,0,102,0,120,0,10,0,134,0,137,0,199,0,74,0,140,0,97,0,111,0,52,0,48,0,89,0,35,0,132,0,143,0,192,0,163,0,4,0,159,0,107,0,0,0,125,0,122,0,0,0,0,0,210,0,176,0,159,0,5,0,164,0,0,0,88,0,134,0,21,0,215,0,23,0,128,0,223,0,27,0,189,0,210,0,168,0,0,0,24,0,120,0,251,0,139,0,220,0,137,0,0,0,102,0,0,0,0,0,175,0,180,0,47,0,82,0,0,0,232,0,36,0,26,0,207,0,112,0,154,0,0,0,0,0,0,0,134,0,136,0,11,0,0,0,212,0,162,0,0,0,220,0,0,0,157,0,81,0,35,0,0,0,164,0,0,0,23,0,136,0,93,0,218,0,147,0,140,0,0,0,113,0,20,0,0,0,247,0,125,0,0,0,35,0,112,0,247,0,106,0,0,0,167,0,33,0,0,0,72,0,92,0,145,0,134,0,165,0,226,0,30,0,0,0,78,0,227,0,247,0,46,0,0,0,51,0,0,0,194,0,218,0,59,0,106,0,55,0,0,0,224,0,50,0,34,0,98,0,84,0,169,0,66,0,254,0,0,0,131,0,194,0,178,0,145,0,174,0,0,0,250,0,11,0,218,0,19,0,156,0,0,0,106,0,246,0,197,0,50,0,28,0,252,0,21,0,69,0,71,0,70,0,238,0,126,0,47,0,59,0,15,0,111,0,92,0,0,0,0,0,252,0,245,0,243,0,48,0,21,0,50,0,0,0,0,0,98,0,180,0,20,0,30,0,146,0,25,0,219,0,132,0,119,0,31,0,160,0,123,0,72,0,39,0,243,0,5,0,0,0,132,0,231,0,95,0,202,0,137,0,4,0,86,0,7,0,113,0,213,0,0,0,239,0,0,0,140,0,236,0,133,0,122,0,166,0,174,0,0,0,0,0,0,0,0,0,247,0,0,0,0,0,178,0,178,0,0,0,0,0,244,0,0,0,0,0,187,0,0,0,49,0,230,0,171,0,57,0,140,0,93,0,89,0,239,0,232,0,28,0,0,0,241,0,0,0,29,0,184,0,16,0,69,0,214,0,14,0,150,0,12,0,60,0,125,0,59,0,253,0,235,0,4,0,28,0,0,0,95,0,183,0,91,0,251,0,0,0,0,0,0,0,0,0,237,0,71,0,191,0,187,0,52,0,46,0,110,0,27,0,0,0,0,0,0,0,135,0,48,0,220,0,4,0,0,0,86,0,74,0,0,0,232,0,57,0,159,0,116,0,0,0,41,0,0,0,150,0,0,0,0,0,140,0,147,0,151,0,95,0,182,0,154,0,246,0,191,0,98,0,194,0,109,0,50,0,216,0,193,0,13,0,0,0,189,0,72,0,0,0,155,0,223,0,214,0,255,0,134,0,130,0,0,0,181,0,62,0,120,0,109,0,214,0,243,0,0,0,188,0,218,0,194,0,174,0,26,0,162,0,73,0,125,0,130,0,79,0,170,0,34,0,176,0,110,0,0,0,135,0,180,0,34,0,0,0,123,0,72,0,0,0,193,0,17,0,148,0,0,0,81,0,52,0,0,0,175,0,27,0,164,0,50,0,230,0,48,0,0,0,0,0,119,0,171,0,122,0,243,0,163,0,251,0,236,0,0,0,36,0,122,0,241,0,80,0,46,0,135,0,48,0,66,0,15,0,6,0,142,0,117,0);
signal scenario_full  : scenario_type := (0,0,12,31,20,31,20,30,20,29,68,31,114,31,114,30,175,31,201,31,166,31,84,31,48,31,48,30,69,31,204,31,8,31,146,31,55,31,55,30,228,31,228,31,229,31,94,31,94,31,52,31,52,30,50,31,22,31,22,30,23,31,169,31,212,31,199,31,83,31,83,30,61,31,160,31,66,31,66,30,64,31,64,30,17,31,132,31,92,31,213,31,146,31,23,31,138,31,185,31,82,31,212,31,99,31,99,30,168,31,164,31,24,31,7,31,99,31,99,30,53,31,45,31,113,31,84,31,84,30,157,31,20,31,133,31,40,31,40,30,189,31,189,30,158,31,245,31,14,31,183,31,167,31,180,31,180,30,188,31,59,31,165,31,64,31,200,31,64,31,99,31,243,31,231,31,231,30,231,29,80,31,80,30,84,31,84,30,139,31,152,31,152,30,72,31,9,31,51,31,67,31,24,31,73,31,73,30,149,31,47,31,11,31,59,31,26,31,189,31,138,31,138,30,236,31,236,30,40,31,156,31,209,31,150,31,6,31,89,31,102,31,120,31,10,31,134,31,137,31,199,31,74,31,140,31,97,31,111,31,52,31,48,31,89,31,35,31,132,31,143,31,192,31,163,31,4,31,159,31,107,31,107,30,125,31,122,31,122,30,122,29,210,31,176,31,159,31,5,31,164,31,164,30,88,31,134,31,21,31,215,31,23,31,128,31,223,31,27,31,189,31,210,31,168,31,168,30,24,31,120,31,251,31,139,31,220,31,137,31,137,30,102,31,102,30,102,29,175,31,180,31,47,31,82,31,82,30,232,31,36,31,26,31,207,31,112,31,154,31,154,30,154,29,154,28,134,31,136,31,11,31,11,30,212,31,162,31,162,30,220,31,220,30,157,31,81,31,35,31,35,30,164,31,164,30,23,31,136,31,93,31,218,31,147,31,140,31,140,30,113,31,20,31,20,30,247,31,125,31,125,30,35,31,112,31,247,31,106,31,106,30,167,31,33,31,33,30,72,31,92,31,145,31,134,31,165,31,226,31,30,31,30,30,78,31,227,31,247,31,46,31,46,30,51,31,51,30,194,31,218,31,59,31,106,31,55,31,55,30,224,31,50,31,34,31,98,31,84,31,169,31,66,31,254,31,254,30,131,31,194,31,178,31,145,31,174,31,174,30,250,31,11,31,218,31,19,31,156,31,156,30,106,31,246,31,197,31,50,31,28,31,252,31,21,31,69,31,71,31,70,31,238,31,126,31,47,31,59,31,15,31,111,31,92,31,92,30,92,29,252,31,245,31,243,31,48,31,21,31,50,31,50,30,50,29,98,31,180,31,20,31,30,31,146,31,25,31,219,31,132,31,119,31,31,31,160,31,123,31,72,31,39,31,243,31,5,31,5,30,132,31,231,31,95,31,202,31,137,31,4,31,86,31,7,31,113,31,213,31,213,30,239,31,239,30,140,31,236,31,133,31,122,31,166,31,174,31,174,30,174,29,174,28,174,27,247,31,247,30,247,29,178,31,178,31,178,30,178,29,244,31,244,30,244,29,187,31,187,30,49,31,230,31,171,31,57,31,140,31,93,31,89,31,239,31,232,31,28,31,28,30,241,31,241,30,29,31,184,31,16,31,69,31,214,31,14,31,150,31,12,31,60,31,125,31,59,31,253,31,235,31,4,31,28,31,28,30,95,31,183,31,91,31,251,31,251,30,251,29,251,28,251,27,237,31,71,31,191,31,187,31,52,31,46,31,110,31,27,31,27,30,27,29,27,28,135,31,48,31,220,31,4,31,4,30,86,31,74,31,74,30,232,31,57,31,159,31,116,31,116,30,41,31,41,30,150,31,150,30,150,29,140,31,147,31,151,31,95,31,182,31,154,31,246,31,191,31,98,31,194,31,109,31,50,31,216,31,193,31,13,31,13,30,189,31,72,31,72,30,155,31,223,31,214,31,255,31,134,31,130,31,130,30,181,31,62,31,120,31,109,31,214,31,243,31,243,30,188,31,218,31,194,31,174,31,26,31,162,31,73,31,125,31,130,31,79,31,170,31,34,31,176,31,110,31,110,30,135,31,180,31,34,31,34,30,123,31,72,31,72,30,193,31,17,31,148,31,148,30,81,31,52,31,52,30,175,31,27,31,164,31,50,31,230,31,48,31,48,30,48,29,119,31,171,31,122,31,243,31,163,31,251,31,236,31,236,30,36,31,122,31,241,31,80,31,46,31,135,31,48,31,66,31,15,31,6,31,142,31,117,31);

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
