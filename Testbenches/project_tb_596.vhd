-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_596 is
end project_tb_596;

architecture project_tb_arch_596 of project_tb_596 is
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

constant SCENARIO_LENGTH : integer := 598;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (220,0,126,0,182,0,0,0,42,0,68,0,204,0,37,0,0,0,246,0,92,0,116,0,0,0,15,0,17,0,142,0,64,0,153,0,141,0,192,0,179,0,7,0,0,0,141,0,112,0,0,0,50,0,151,0,38,0,0,0,65,0,0,0,21,0,85,0,96,0,49,0,195,0,122,0,0,0,75,0,180,0,0,0,54,0,247,0,252,0,105,0,0,0,0,0,162,0,141,0,44,0,172,0,91,0,209,0,226,0,0,0,40,0,134,0,41,0,206,0,7,0,0,0,148,0,220,0,233,0,80,0,0,0,147,0,205,0,243,0,141,0,99,0,0,0,59,0,13,0,0,0,164,0,198,0,0,0,72,0,172,0,233,0,115,0,234,0,112,0,24,0,0,0,50,0,194,0,3,0,242,0,0,0,123,0,174,0,68,0,8,0,147,0,121,0,133,0,222,0,233,0,222,0,70,0,0,0,171,0,207,0,0,0,179,0,175,0,28,0,38,0,59,0,67,0,182,0,234,0,196,0,15,0,0,0,0,0,10,0,0,0,221,0,0,0,106,0,168,0,136,0,162,0,246,0,208,0,106,0,27,0,0,0,31,0,0,0,206,0,228,0,0,0,224,0,207,0,9,0,0,0,0,0,88,0,245,0,15,0,0,0,74,0,6,0,238,0,78,0,148,0,65,0,104,0,217,0,246,0,130,0,142,0,194,0,252,0,10,0,239,0,196,0,95,0,27,0,190,0,11,0,171,0,0,0,194,0,0,0,104,0,83,0,0,0,25,0,179,0,36,0,105,0,144,0,163,0,103,0,76,0,231,0,135,0,102,0,155,0,243,0,36,0,83,0,224,0,94,0,190,0,84,0,0,0,75,0,157,0,184,0,0,0,191,0,78,0,250,0,101,0,73,0,0,0,168,0,0,0,0,0,0,0,0,0,188,0,174,0,196,0,180,0,186,0,181,0,0,0,238,0,2,0,236,0,135,0,92,0,160,0,0,0,200,0,144,0,79,0,141,0,26,0,129,0,237,0,225,0,53,0,101,0,62,0,157,0,132,0,51,0,160,0,223,0,79,0,83,0,227,0,106,0,134,0,0,0,160,0,221,0,0,0,0,0,0,0,0,0,0,0,214,0,221,0,248,0,101,0,80,0,197,0,0,0,110,0,12,0,102,0,236,0,106,0,4,0,97,0,134,0,83,0,0,0,25,0,90,0,76,0,0,0,159,0,193,0,0,0,140,0,239,0,116,0,218,0,175,0,98,0,122,0,161,0,39,0,106,0,61,0,185,0,0,0,91,0,183,0,50,0,110,0,0,0,207,0,74,0,200,0,191,0,213,0,83,0,0,0,216,0,17,0,0,0,0,0,211,0,0,0,234,0,211,0,57,0,170,0,123,0,56,0,128,0,214,0,0,0,61,0,0,0,149,0,105,0,113,0,27,0,159,0,234,0,244,0,214,0,242,0,0,0,103,0,0,0,0,0,110,0,157,0,60,0,148,0,0,0,204,0,36,0,209,0,75,0,203,0,0,0,137,0,217,0,195,0,60,0,97,0,254,0,28,0,48,0,75,0,110,0,25,0,234,0,38,0,0,0,133,0,193,0,123,0,208,0,0,0,0,0,134,0,0,0,211,0,25,0,0,0,253,0,0,0,77,0,166,0,238,0,125,0,178,0,0,0,210,0,13,0,20,0,52,0,82,0,41,0,0,0,85,0,42,0,0,0,56,0,157,0,61,0,58,0,202,0,180,0,196,0,240,0,76,0,182,0,0,0,190,0,0,0,27,0,197,0,0,0,160,0,13,0,239,0,28,0,121,0,181,0,51,0,0,0,0,0,69,0,202,0,0,0,7,0,79,0,225,0,0,0,26,0,39,0,0,0,7,0,225,0,33,0,35,0,0,0,0,0,137,0,28,0,153,0,4,0,189,0,0,0,197,0,201,0,181,0,246,0,47,0,0,0,148,0,187,0,222,0,237,0,138,0,70,0,0,0,151,0,189,0,149,0,202,0,233,0,138,0,200,0,66,0,210,0,223,0,227,0,0,0,127,0,77,0,99,0,251,0,0,0,65,0,51,0,78,0,82,0,27,0,16,0,134,0,0,0,168,0,219,0,64,0,144,0,77,0,69,0,55,0,0,0,0,0,34,0,53,0,21,0,39,0,50,0,100,0,200,0,160,0,0,0,157,0,250,0,0,0,133,0,71,0,219,0,88,0,84,0,187,0,213,0,41,0,51,0,126,0,0,0,31,0,27,0,237,0,198,0,79,0,74,0,84,0,47,0,174,0,30,0,216,0,0,0,0,0,95,0,130,0,198,0,0,0,0,0,0,0,245,0,168,0,8,0,79,0,0,0,40,0,0,0,96,0,19,0,0,0,233,0,7,0,143,0,180,0,0,0,188,0,175,0,0,0,0,0,0,0,190,0,12,0,247,0,10,0,0,0,0,0,5,0,3,0,227,0,93,0,128,0,0,0,123,0,172,0,0,0,11,0,107,0,0,0,247,0,22,0,46,0,173,0,227,0,227,0,252,0,9,0,0,0,0,0,0,0,230,0,249,0,204,0,0,0,212,0,100,0,149,0,223,0,36,0,144,0,253,0,135,0,186,0,248,0,123,0,0,0,0,0,189,0,54,0,132,0,131,0,0,0,110,0,145,0,194,0,14,0,162,0,157,0,0,0);
signal scenario_full  : scenario_type := (220,31,126,31,182,31,182,30,42,31,68,31,204,31,37,31,37,30,246,31,92,31,116,31,116,30,15,31,17,31,142,31,64,31,153,31,141,31,192,31,179,31,7,31,7,30,141,31,112,31,112,30,50,31,151,31,38,31,38,30,65,31,65,30,21,31,85,31,96,31,49,31,195,31,122,31,122,30,75,31,180,31,180,30,54,31,247,31,252,31,105,31,105,30,105,29,162,31,141,31,44,31,172,31,91,31,209,31,226,31,226,30,40,31,134,31,41,31,206,31,7,31,7,30,148,31,220,31,233,31,80,31,80,30,147,31,205,31,243,31,141,31,99,31,99,30,59,31,13,31,13,30,164,31,198,31,198,30,72,31,172,31,233,31,115,31,234,31,112,31,24,31,24,30,50,31,194,31,3,31,242,31,242,30,123,31,174,31,68,31,8,31,147,31,121,31,133,31,222,31,233,31,222,31,70,31,70,30,171,31,207,31,207,30,179,31,175,31,28,31,38,31,59,31,67,31,182,31,234,31,196,31,15,31,15,30,15,29,10,31,10,30,221,31,221,30,106,31,168,31,136,31,162,31,246,31,208,31,106,31,27,31,27,30,31,31,31,30,206,31,228,31,228,30,224,31,207,31,9,31,9,30,9,29,88,31,245,31,15,31,15,30,74,31,6,31,238,31,78,31,148,31,65,31,104,31,217,31,246,31,130,31,142,31,194,31,252,31,10,31,239,31,196,31,95,31,27,31,190,31,11,31,171,31,171,30,194,31,194,30,104,31,83,31,83,30,25,31,179,31,36,31,105,31,144,31,163,31,103,31,76,31,231,31,135,31,102,31,155,31,243,31,36,31,83,31,224,31,94,31,190,31,84,31,84,30,75,31,157,31,184,31,184,30,191,31,78,31,250,31,101,31,73,31,73,30,168,31,168,30,168,29,168,28,168,27,188,31,174,31,196,31,180,31,186,31,181,31,181,30,238,31,2,31,236,31,135,31,92,31,160,31,160,30,200,31,144,31,79,31,141,31,26,31,129,31,237,31,225,31,53,31,101,31,62,31,157,31,132,31,51,31,160,31,223,31,79,31,83,31,227,31,106,31,134,31,134,30,160,31,221,31,221,30,221,29,221,28,221,27,221,26,214,31,221,31,248,31,101,31,80,31,197,31,197,30,110,31,12,31,102,31,236,31,106,31,4,31,97,31,134,31,83,31,83,30,25,31,90,31,76,31,76,30,159,31,193,31,193,30,140,31,239,31,116,31,218,31,175,31,98,31,122,31,161,31,39,31,106,31,61,31,185,31,185,30,91,31,183,31,50,31,110,31,110,30,207,31,74,31,200,31,191,31,213,31,83,31,83,30,216,31,17,31,17,30,17,29,211,31,211,30,234,31,211,31,57,31,170,31,123,31,56,31,128,31,214,31,214,30,61,31,61,30,149,31,105,31,113,31,27,31,159,31,234,31,244,31,214,31,242,31,242,30,103,31,103,30,103,29,110,31,157,31,60,31,148,31,148,30,204,31,36,31,209,31,75,31,203,31,203,30,137,31,217,31,195,31,60,31,97,31,254,31,28,31,48,31,75,31,110,31,25,31,234,31,38,31,38,30,133,31,193,31,123,31,208,31,208,30,208,29,134,31,134,30,211,31,25,31,25,30,253,31,253,30,77,31,166,31,238,31,125,31,178,31,178,30,210,31,13,31,20,31,52,31,82,31,41,31,41,30,85,31,42,31,42,30,56,31,157,31,61,31,58,31,202,31,180,31,196,31,240,31,76,31,182,31,182,30,190,31,190,30,27,31,197,31,197,30,160,31,13,31,239,31,28,31,121,31,181,31,51,31,51,30,51,29,69,31,202,31,202,30,7,31,79,31,225,31,225,30,26,31,39,31,39,30,7,31,225,31,33,31,35,31,35,30,35,29,137,31,28,31,153,31,4,31,189,31,189,30,197,31,201,31,181,31,246,31,47,31,47,30,148,31,187,31,222,31,237,31,138,31,70,31,70,30,151,31,189,31,149,31,202,31,233,31,138,31,200,31,66,31,210,31,223,31,227,31,227,30,127,31,77,31,99,31,251,31,251,30,65,31,51,31,78,31,82,31,27,31,16,31,134,31,134,30,168,31,219,31,64,31,144,31,77,31,69,31,55,31,55,30,55,29,34,31,53,31,21,31,39,31,50,31,100,31,200,31,160,31,160,30,157,31,250,31,250,30,133,31,71,31,219,31,88,31,84,31,187,31,213,31,41,31,51,31,126,31,126,30,31,31,27,31,237,31,198,31,79,31,74,31,84,31,47,31,174,31,30,31,216,31,216,30,216,29,95,31,130,31,198,31,198,30,198,29,198,28,245,31,168,31,8,31,79,31,79,30,40,31,40,30,96,31,19,31,19,30,233,31,7,31,143,31,180,31,180,30,188,31,175,31,175,30,175,29,175,28,190,31,12,31,247,31,10,31,10,30,10,29,5,31,3,31,227,31,93,31,128,31,128,30,123,31,172,31,172,30,11,31,107,31,107,30,247,31,22,31,46,31,173,31,227,31,227,31,252,31,9,31,9,30,9,29,9,28,230,31,249,31,204,31,204,30,212,31,100,31,149,31,223,31,36,31,144,31,253,31,135,31,186,31,248,31,123,31,123,30,123,29,189,31,54,31,132,31,131,31,131,30,110,31,145,31,194,31,14,31,162,31,157,31,157,30);

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
