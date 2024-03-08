-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_535 is
end project_tb_535;

architecture project_tb_arch_535 of project_tb_535 is
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

constant SCENARIO_LENGTH : integer := 595;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,94,0,78,0,199,0,0,0,0,0,176,0,112,0,92,0,245,0,117,0,194,0,184,0,28,0,85,0,147,0,90,0,0,0,217,0,117,0,19,0,86,0,158,0,0,0,200,0,234,0,117,0,229,0,0,0,235,0,240,0,238,0,157,0,155,0,16,0,146,0,206,0,107,0,100,0,150,0,0,0,67,0,107,0,250,0,141,0,30,0,244,0,0,0,126,0,221,0,215,0,207,0,123,0,0,0,103,0,249,0,169,0,121,0,228,0,203,0,200,0,19,0,84,0,0,0,186,0,184,0,0,0,243,0,120,0,104,0,175,0,0,0,109,0,51,0,0,0,56,0,44,0,0,0,0,0,71,0,0,0,173,0,105,0,99,0,0,0,0,0,0,0,129,0,0,0,0,0,0,0,231,0,222,0,0,0,59,0,253,0,0,0,103,0,73,0,96,0,9,0,173,0,51,0,0,0,47,0,93,0,228,0,11,0,61,0,35,0,73,0,226,0,187,0,220,0,245,0,71,0,0,0,80,0,106,0,225,0,154,0,196,0,220,0,42,0,25,0,165,0,0,0,59,0,0,0,120,0,17,0,242,0,0,0,206,0,101,0,81,0,37,0,0,0,72,0,141,0,97,0,51,0,59,0,197,0,229,0,222,0,189,0,206,0,33,0,85,0,50,0,5,0,92,0,127,0,223,0,0,0,224,0,0,0,234,0,53,0,228,0,34,0,113,0,16,0,67,0,93,0,139,0,120,0,15,0,0,0,0,0,31,0,108,0,235,0,30,0,52,0,105,0,142,0,42,0,162,0,176,0,8,0,198,0,133,0,232,0,242,0,134,0,203,0,245,0,97,0,109,0,52,0,0,0,77,0,119,0,54,0,219,0,238,0,0,0,107,0,218,0,19,0,131,0,253,0,113,0,138,0,45,0,120,0,103,0,163,0,21,0,197,0,50,0,0,0,149,0,118,0,213,0,4,0,234,0,111,0,0,0,15,0,20,0,68,0,0,0,0,0,127,0,41,0,41,0,0,0,16,0,55,0,41,0,0,0,162,0,130,0,176,0,0,0,0,0,41,0,139,0,154,0,69,0,0,0,0,0,89,0,149,0,0,0,177,0,214,0,0,0,134,0,113,0,199,0,202,0,0,0,183,0,235,0,229,0,0,0,0,0,255,0,164,0,0,0,186,0,212,0,117,0,0,0,0,0,82,0,184,0,90,0,66,0,155,0,66,0,19,0,61,0,0,0,82,0,0,0,97,0,29,0,119,0,230,0,0,0,38,0,113,0,100,0,134,0,7,0,190,0,52,0,194,0,221,0,0,0,75,0,48,0,163,0,0,0,0,0,79,0,0,0,162,0,200,0,154,0,56,0,0,0,205,0,3,0,0,0,0,0,17,0,112,0,153,0,235,0,159,0,219,0,64,0,202,0,53,0,217,0,211,0,238,0,248,0,250,0,61,0,204,0,18,0,238,0,121,0,180,0,204,0,114,0,125,0,170,0,163,0,210,0,229,0,0,0,0,0,0,0,52,0,244,0,0,0,180,0,61,0,215,0,239,0,43,0,42,0,196,0,0,0,69,0,15,0,0,0,88,0,122,0,64,0,228,0,85,0,0,0,88,0,139,0,240,0,15,0,246,0,0,0,0,0,25,0,144,0,190,0,68,0,213,0,79,0,6,0,150,0,70,0,0,0,15,0,24,0,122,0,0,0,38,0,212,0,0,0,103,0,107,0,0,0,94,0,141,0,162,0,0,0,0,0,0,0,0,0,156,0,187,0,203,0,218,0,0,0,66,0,0,0,147,0,0,0,127,0,82,0,226,0,21,0,0,0,218,0,187,0,43,0,143,0,0,0,0,0,170,0,50,0,83,0,207,0,133,0,141,0,232,0,0,0,144,0,0,0,216,0,0,0,234,0,250,0,74,0,255,0,181,0,252,0,18,0,203,0,254,0,96,0,63,0,80,0,146,0,244,0,126,0,0,0,83,0,88,0,110,0,203,0,95,0,37,0,160,0,60,0,255,0,0,0,107,0,0,0,22,0,184,0,13,0,81,0,79,0,89,0,88,0,211,0,124,0,0,0,198,0,0,0,0,0,137,0,102,0,189,0,173,0,172,0,148,0,33,0,0,0,131,0,48,0,0,0,0,0,0,0,75,0,80,0,47,0,0,0,86,0,0,0,0,0,236,0,227,0,28,0,73,0,61,0,37,0,84,0,0,0,57,0,232,0,78,0,163,0,0,0,15,0,0,0,202,0,145,0,2,0,133,0,9,0,66,0,60,0,226,0,236,0,124,0,48,0,81,0,0,0,44,0,219,0,152,0,169,0,61,0,3,0,113,0,14,0,219,0,115,0,0,0,137,0,0,0,94,0,49,0,172,0,7,0,225,0,40,0,175,0,190,0,171,0,97,0,0,0,0,0,0,0,0,0,165,0,0,0,0,0,0,0,0,0,233,0,86,0,154,0,0,0,45,0,0,0,31,0,102,0,0,0,250,0,0,0,33,0,36,0,210,0,137,0,0,0,24,0,105,0,121,0,181,0,92,0,166,0,239,0,0,0,103,0,133,0,0,0,0,0,0,0,208,0,63,0,78,0,60,0,42,0,9,0,154,0,150,0,0,0,109,0,0,0,163,0,0,0,61,0,111,0,37,0,230,0,124,0);
signal scenario_full  : scenario_type := (0,0,94,31,78,31,199,31,199,30,199,29,176,31,112,31,92,31,245,31,117,31,194,31,184,31,28,31,85,31,147,31,90,31,90,30,217,31,117,31,19,31,86,31,158,31,158,30,200,31,234,31,117,31,229,31,229,30,235,31,240,31,238,31,157,31,155,31,16,31,146,31,206,31,107,31,100,31,150,31,150,30,67,31,107,31,250,31,141,31,30,31,244,31,244,30,126,31,221,31,215,31,207,31,123,31,123,30,103,31,249,31,169,31,121,31,228,31,203,31,200,31,19,31,84,31,84,30,186,31,184,31,184,30,243,31,120,31,104,31,175,31,175,30,109,31,51,31,51,30,56,31,44,31,44,30,44,29,71,31,71,30,173,31,105,31,99,31,99,30,99,29,99,28,129,31,129,30,129,29,129,28,231,31,222,31,222,30,59,31,253,31,253,30,103,31,73,31,96,31,9,31,173,31,51,31,51,30,47,31,93,31,228,31,11,31,61,31,35,31,73,31,226,31,187,31,220,31,245,31,71,31,71,30,80,31,106,31,225,31,154,31,196,31,220,31,42,31,25,31,165,31,165,30,59,31,59,30,120,31,17,31,242,31,242,30,206,31,101,31,81,31,37,31,37,30,72,31,141,31,97,31,51,31,59,31,197,31,229,31,222,31,189,31,206,31,33,31,85,31,50,31,5,31,92,31,127,31,223,31,223,30,224,31,224,30,234,31,53,31,228,31,34,31,113,31,16,31,67,31,93,31,139,31,120,31,15,31,15,30,15,29,31,31,108,31,235,31,30,31,52,31,105,31,142,31,42,31,162,31,176,31,8,31,198,31,133,31,232,31,242,31,134,31,203,31,245,31,97,31,109,31,52,31,52,30,77,31,119,31,54,31,219,31,238,31,238,30,107,31,218,31,19,31,131,31,253,31,113,31,138,31,45,31,120,31,103,31,163,31,21,31,197,31,50,31,50,30,149,31,118,31,213,31,4,31,234,31,111,31,111,30,15,31,20,31,68,31,68,30,68,29,127,31,41,31,41,31,41,30,16,31,55,31,41,31,41,30,162,31,130,31,176,31,176,30,176,29,41,31,139,31,154,31,69,31,69,30,69,29,89,31,149,31,149,30,177,31,214,31,214,30,134,31,113,31,199,31,202,31,202,30,183,31,235,31,229,31,229,30,229,29,255,31,164,31,164,30,186,31,212,31,117,31,117,30,117,29,82,31,184,31,90,31,66,31,155,31,66,31,19,31,61,31,61,30,82,31,82,30,97,31,29,31,119,31,230,31,230,30,38,31,113,31,100,31,134,31,7,31,190,31,52,31,194,31,221,31,221,30,75,31,48,31,163,31,163,30,163,29,79,31,79,30,162,31,200,31,154,31,56,31,56,30,205,31,3,31,3,30,3,29,17,31,112,31,153,31,235,31,159,31,219,31,64,31,202,31,53,31,217,31,211,31,238,31,248,31,250,31,61,31,204,31,18,31,238,31,121,31,180,31,204,31,114,31,125,31,170,31,163,31,210,31,229,31,229,30,229,29,229,28,52,31,244,31,244,30,180,31,61,31,215,31,239,31,43,31,42,31,196,31,196,30,69,31,15,31,15,30,88,31,122,31,64,31,228,31,85,31,85,30,88,31,139,31,240,31,15,31,246,31,246,30,246,29,25,31,144,31,190,31,68,31,213,31,79,31,6,31,150,31,70,31,70,30,15,31,24,31,122,31,122,30,38,31,212,31,212,30,103,31,107,31,107,30,94,31,141,31,162,31,162,30,162,29,162,28,162,27,156,31,187,31,203,31,218,31,218,30,66,31,66,30,147,31,147,30,127,31,82,31,226,31,21,31,21,30,218,31,187,31,43,31,143,31,143,30,143,29,170,31,50,31,83,31,207,31,133,31,141,31,232,31,232,30,144,31,144,30,216,31,216,30,234,31,250,31,74,31,255,31,181,31,252,31,18,31,203,31,254,31,96,31,63,31,80,31,146,31,244,31,126,31,126,30,83,31,88,31,110,31,203,31,95,31,37,31,160,31,60,31,255,31,255,30,107,31,107,30,22,31,184,31,13,31,81,31,79,31,89,31,88,31,211,31,124,31,124,30,198,31,198,30,198,29,137,31,102,31,189,31,173,31,172,31,148,31,33,31,33,30,131,31,48,31,48,30,48,29,48,28,75,31,80,31,47,31,47,30,86,31,86,30,86,29,236,31,227,31,28,31,73,31,61,31,37,31,84,31,84,30,57,31,232,31,78,31,163,31,163,30,15,31,15,30,202,31,145,31,2,31,133,31,9,31,66,31,60,31,226,31,236,31,124,31,48,31,81,31,81,30,44,31,219,31,152,31,169,31,61,31,3,31,113,31,14,31,219,31,115,31,115,30,137,31,137,30,94,31,49,31,172,31,7,31,225,31,40,31,175,31,190,31,171,31,97,31,97,30,97,29,97,28,97,27,165,31,165,30,165,29,165,28,165,27,233,31,86,31,154,31,154,30,45,31,45,30,31,31,102,31,102,30,250,31,250,30,33,31,36,31,210,31,137,31,137,30,24,31,105,31,121,31,181,31,92,31,166,31,239,31,239,30,103,31,133,31,133,30,133,29,133,28,208,31,63,31,78,31,60,31,42,31,9,31,154,31,150,31,150,30,109,31,109,30,163,31,163,30,61,31,111,31,37,31,230,31,124,31);

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
