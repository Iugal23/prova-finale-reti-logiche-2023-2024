-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_152 is
end project_tb_152;

architecture project_tb_arch_152 of project_tb_152 is
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

constant SCENARIO_LENGTH : integer := 554;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (179,0,0,0,154,0,72,0,86,0,114,0,183,0,46,0,108,0,49,0,251,0,88,0,86,0,0,0,0,0,0,0,102,0,70,0,0,0,14,0,70,0,252,0,137,0,105,0,0,0,134,0,96,0,0,0,140,0,109,0,40,0,71,0,36,0,0,0,134,0,33,0,5,0,27,0,201,0,43,0,142,0,15,0,208,0,239,0,237,0,53,0,204,0,0,0,125,0,173,0,244,0,57,0,90,0,63,0,36,0,188,0,214,0,15,0,225,0,81,0,17,0,194,0,0,0,158,0,51,0,22,0,0,0,136,0,127,0,182,0,0,0,6,0,183,0,237,0,252,0,114,0,243,0,42,0,0,0,174,0,204,0,142,0,23,0,175,0,119,0,145,0,177,0,0,0,89,0,77,0,94,0,126,0,185,0,198,0,245,0,0,0,127,0,0,0,55,0,187,0,0,0,221,0,213,0,10,0,0,0,45,0,0,0,204,0,23,0,0,0,177,0,157,0,236,0,171,0,110,0,173,0,118,0,0,0,49,0,71,0,136,0,0,0,237,0,28,0,178,0,253,0,209,0,158,0,247,0,0,0,172,0,242,0,59,0,47,0,148,0,181,0,237,0,0,0,248,0,81,0,16,0,68,0,39,0,192,0,0,0,202,0,221,0,228,0,245,0,0,0,14,0,147,0,247,0,122,0,95,0,80,0,107,0,17,0,84,0,43,0,247,0,24,0,184,0,123,0,170,0,215,0,22,0,44,0,63,0,241,0,104,0,104,0,183,0,83,0,66,0,73,0,174,0,203,0,149,0,118,0,68,0,0,0,144,0,52,0,246,0,234,0,223,0,0,0,247,0,0,0,112,0,127,0,0,0,179,0,57,0,178,0,115,0,0,0,47,0,65,0,74,0,131,0,225,0,127,0,184,0,248,0,0,0,242,0,113,0,22,0,48,0,85,0,1,0,177,0,104,0,156,0,40,0,63,0,230,0,131,0,169,0,233,0,67,0,30,0,179,0,76,0,55,0,243,0,215,0,33,0,245,0,209,0,20,0,194,0,140,0,12,0,150,0,241,0,3,0,223,0,86,0,42,0,174,0,48,0,221,0,10,0,0,0,233,0,190,0,228,0,201,0,218,0,163,0,172,0,169,0,108,0,71,0,59,0,0,0,160,0,0,0,47,0,0,0,228,0,5,0,0,0,189,0,154,0,235,0,0,0,0,0,234,0,10,0,255,0,251,0,246,0,204,0,186,0,253,0,236,0,68,0,255,0,189,0,187,0,0,0,147,0,39,0,110,0,220,0,177,0,0,0,0,0,222,0,46,0,7,0,42,0,15,0,234,0,210,0,56,0,242,0,17,0,0,0,206,0,0,0,0,0,243,0,101,0,0,0,81,0,29,0,222,0,5,0,226,0,65,0,150,0,187,0,0,0,2,0,143,0,60,0,91,0,110,0,229,0,41,0,226,0,133,0,153,0,192,0,0,0,0,0,123,0,13,0,34,0,0,0,158,0,229,0,128,0,211,0,100,0,0,0,0,0,66,0,130,0,0,0,221,0,199,0,0,0,73,0,222,0,22,0,0,0,156,0,0,0,111,0,143,0,235,0,100,0,6,0,216,0,92,0,238,0,84,0,196,0,71,0,217,0,71,0,233,0,248,0,0,0,199,0,135,0,13,0,144,0,0,0,76,0,49,0,70,0,196,0,0,0,93,0,28,0,240,0,0,0,115,0,120,0,252,0,141,0,38,0,221,0,122,0,240,0,65,0,212,0,69,0,188,0,169,0,137,0,234,0,0,0,248,0,93,0,218,0,0,0,124,0,159,0,198,0,66,0,138,0,5,0,52,0,130,0,203,0,46,0,144,0,243,0,135,0,165,0,59,0,75,0,64,0,0,0,144,0,0,0,207,0,0,0,103,0,10,0,115,0,207,0,115,0,28,0,231,0,227,0,174,0,212,0,126,0,0,0,89,0,111,0,226,0,15,0,0,0,61,0,0,0,194,0,0,0,148,0,120,0,0,0,80,0,92,0,217,0,66,0,59,0,31,0,146,0,194,0,186,0,0,0,17,0,0,0,193,0,0,0,1,0,31,0,171,0,136,0,150,0,0,0,240,0,91,0,0,0,203,0,0,0,186,0,28,0,237,0,98,0,224,0,222,0,194,0,20,0,93,0,0,0,0,0,124,0,209,0,87,0,148,0,151,0,0,0,68,0,59,0,61,0,0,0,60,0,11,0,209,0,140,0,173,0,104,0,97,0,230,0,151,0,215,0,228,0,255,0,65,0,228,0,57,0,144,0,170,0,165,0,0,0,233,0,46,0,0,0,226,0,52,0,134,0,91,0,0,0,193,0,69,0,105,0,207,0,24,0,48,0,0,0,126,0,46,0,0,0,0,0,218,0,160,0,244,0,114,0,199,0,49,0,0,0,0,0,51,0,244,0,16,0,0,0,70,0,255,0,46,0,0,0,0,0,136,0,85,0,239,0);
signal scenario_full  : scenario_type := (179,31,179,30,154,31,72,31,86,31,114,31,183,31,46,31,108,31,49,31,251,31,88,31,86,31,86,30,86,29,86,28,102,31,70,31,70,30,14,31,70,31,252,31,137,31,105,31,105,30,134,31,96,31,96,30,140,31,109,31,40,31,71,31,36,31,36,30,134,31,33,31,5,31,27,31,201,31,43,31,142,31,15,31,208,31,239,31,237,31,53,31,204,31,204,30,125,31,173,31,244,31,57,31,90,31,63,31,36,31,188,31,214,31,15,31,225,31,81,31,17,31,194,31,194,30,158,31,51,31,22,31,22,30,136,31,127,31,182,31,182,30,6,31,183,31,237,31,252,31,114,31,243,31,42,31,42,30,174,31,204,31,142,31,23,31,175,31,119,31,145,31,177,31,177,30,89,31,77,31,94,31,126,31,185,31,198,31,245,31,245,30,127,31,127,30,55,31,187,31,187,30,221,31,213,31,10,31,10,30,45,31,45,30,204,31,23,31,23,30,177,31,157,31,236,31,171,31,110,31,173,31,118,31,118,30,49,31,71,31,136,31,136,30,237,31,28,31,178,31,253,31,209,31,158,31,247,31,247,30,172,31,242,31,59,31,47,31,148,31,181,31,237,31,237,30,248,31,81,31,16,31,68,31,39,31,192,31,192,30,202,31,221,31,228,31,245,31,245,30,14,31,147,31,247,31,122,31,95,31,80,31,107,31,17,31,84,31,43,31,247,31,24,31,184,31,123,31,170,31,215,31,22,31,44,31,63,31,241,31,104,31,104,31,183,31,83,31,66,31,73,31,174,31,203,31,149,31,118,31,68,31,68,30,144,31,52,31,246,31,234,31,223,31,223,30,247,31,247,30,112,31,127,31,127,30,179,31,57,31,178,31,115,31,115,30,47,31,65,31,74,31,131,31,225,31,127,31,184,31,248,31,248,30,242,31,113,31,22,31,48,31,85,31,1,31,177,31,104,31,156,31,40,31,63,31,230,31,131,31,169,31,233,31,67,31,30,31,179,31,76,31,55,31,243,31,215,31,33,31,245,31,209,31,20,31,194,31,140,31,12,31,150,31,241,31,3,31,223,31,86,31,42,31,174,31,48,31,221,31,10,31,10,30,233,31,190,31,228,31,201,31,218,31,163,31,172,31,169,31,108,31,71,31,59,31,59,30,160,31,160,30,47,31,47,30,228,31,5,31,5,30,189,31,154,31,235,31,235,30,235,29,234,31,10,31,255,31,251,31,246,31,204,31,186,31,253,31,236,31,68,31,255,31,189,31,187,31,187,30,147,31,39,31,110,31,220,31,177,31,177,30,177,29,222,31,46,31,7,31,42,31,15,31,234,31,210,31,56,31,242,31,17,31,17,30,206,31,206,30,206,29,243,31,101,31,101,30,81,31,29,31,222,31,5,31,226,31,65,31,150,31,187,31,187,30,2,31,143,31,60,31,91,31,110,31,229,31,41,31,226,31,133,31,153,31,192,31,192,30,192,29,123,31,13,31,34,31,34,30,158,31,229,31,128,31,211,31,100,31,100,30,100,29,66,31,130,31,130,30,221,31,199,31,199,30,73,31,222,31,22,31,22,30,156,31,156,30,111,31,143,31,235,31,100,31,6,31,216,31,92,31,238,31,84,31,196,31,71,31,217,31,71,31,233,31,248,31,248,30,199,31,135,31,13,31,144,31,144,30,76,31,49,31,70,31,196,31,196,30,93,31,28,31,240,31,240,30,115,31,120,31,252,31,141,31,38,31,221,31,122,31,240,31,65,31,212,31,69,31,188,31,169,31,137,31,234,31,234,30,248,31,93,31,218,31,218,30,124,31,159,31,198,31,66,31,138,31,5,31,52,31,130,31,203,31,46,31,144,31,243,31,135,31,165,31,59,31,75,31,64,31,64,30,144,31,144,30,207,31,207,30,103,31,10,31,115,31,207,31,115,31,28,31,231,31,227,31,174,31,212,31,126,31,126,30,89,31,111,31,226,31,15,31,15,30,61,31,61,30,194,31,194,30,148,31,120,31,120,30,80,31,92,31,217,31,66,31,59,31,31,31,146,31,194,31,186,31,186,30,17,31,17,30,193,31,193,30,1,31,31,31,171,31,136,31,150,31,150,30,240,31,91,31,91,30,203,31,203,30,186,31,28,31,237,31,98,31,224,31,222,31,194,31,20,31,93,31,93,30,93,29,124,31,209,31,87,31,148,31,151,31,151,30,68,31,59,31,61,31,61,30,60,31,11,31,209,31,140,31,173,31,104,31,97,31,230,31,151,31,215,31,228,31,255,31,65,31,228,31,57,31,144,31,170,31,165,31,165,30,233,31,46,31,46,30,226,31,52,31,134,31,91,31,91,30,193,31,69,31,105,31,207,31,24,31,48,31,48,30,126,31,46,31,46,30,46,29,218,31,160,31,244,31,114,31,199,31,49,31,49,30,49,29,51,31,244,31,16,31,16,30,70,31,255,31,46,31,46,30,46,29,136,31,85,31,239,31);

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
