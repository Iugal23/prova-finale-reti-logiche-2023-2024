-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 470;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,70,0,0,0,192,0,0,0,71,0,155,0,38,0,40,0,128,0,91,0,19,0,0,0,146,0,0,0,122,0,139,0,0,0,60,0,154,0,10,0,0,0,73,0,188,0,25,0,99,0,1,0,178,0,119,0,140,0,130,0,5,0,83,0,174,0,64,0,125,0,82,0,203,0,137,0,38,0,111,0,48,0,21,0,111,0,0,0,71,0,0,0,55,0,148,0,240,0,218,0,165,0,156,0,245,0,73,0,147,0,0,0,108,0,215,0,186,0,242,0,198,0,0,0,255,0,156,0,56,0,128,0,70,0,201,0,0,0,229,0,251,0,162,0,162,0,147,0,217,0,0,0,42,0,0,0,0,0,67,0,204,0,0,0,0,0,0,0,163,0,204,0,229,0,0,0,0,0,0,0,165,0,198,0,46,0,254,0,130,0,0,0,229,0,58,0,147,0,190,0,186,0,27,0,182,0,68,0,68,0,186,0,238,0,106,0,164,0,208,0,0,0,70,0,0,0,0,0,39,0,255,0,0,0,104,0,234,0,71,0,231,0,59,0,43,0,39,0,57,0,0,0,167,0,251,0,0,0,145,0,0,0,158,0,39,0,0,0,140,0,233,0,115,0,59,0,206,0,0,0,0,0,18,0,0,0,190,0,0,0,37,0,177,0,169,0,183,0,0,0,99,0,0,0,67,0,201,0,11,0,4,0,9,0,129,0,191,0,138,0,251,0,143,0,116,0,7,0,84,0,139,0,135,0,134,0,65,0,186,0,0,0,41,0,114,0,164,0,194,0,80,0,247,0,255,0,162,0,1,0,189,0,127,0,253,0,139,0,0,0,0,0,0,0,66,0,197,0,168,0,0,0,189,0,52,0,5,0,97,0,70,0,0,0,161,0,236,0,123,0,110,0,0,0,13,0,70,0,150,0,76,0,0,0,0,0,182,0,72,0,144,0,152,0,44,0,198,0,148,0,0,0,68,0,77,0,226,0,15,0,0,0,143,0,0,0,60,0,0,0,203,0,223,0,76,0,197,0,214,0,57,0,0,0,109,0,0,0,0,0,0,0,123,0,0,0,187,0,112,0,0,0,186,0,22,0,109,0,92,0,17,0,138,0,0,0,240,0,17,0,8,0,248,0,0,0,88,0,146,0,234,0,170,0,174,0,198,0,160,0,73,0,216,0,176,0,201,0,215,0,154,0,106,0,162,0,0,0,0,0,12,0,179,0,3,0,12,0,88,0,51,0,110,0,225,0,0,0,243,0,123,0,9,0,177,0,101,0,164,0,75,0,154,0,0,0,184,0,0,0,55,0,75,0,0,0,216,0,146,0,0,0,136,0,235,0,44,0,81,0,207,0,0,0,60,0,0,0,0,0,207,0,0,0,0,0,157,0,116,0,29,0,239,0,202,0,0,0,0,0,153,0,0,0,179,0,130,0,180,0,0,0,125,0,69,0,145,0,93,0,200,0,126,0,0,0,174,0,255,0,0,0,0,0,77,0,82,0,67,0,20,0,144,0,243,0,54,0,90,0,130,0,0,0,84,0,17,0,247,0,0,0,28,0,161,0,61,0,0,0,65,0,0,0,144,0,68,0,13,0,205,0,225,0,194,0,0,0,83,0,248,0,204,0,132,0,113,0,220,0,14,0,0,0,215,0,52,0,0,0,90,0,58,0,161,0,251,0,0,0,108,0,118,0,0,0,104,0,94,0,144,0,223,0,43,0,33,0,211,0,165,0,65,0,0,0,38,0,0,0,235,0,169,0,0,0,0,0,97,0,16,0,0,0,183,0,7,0,241,0,137,0,0,0,186,0,232,0,91,0,27,0,0,0,0,0,142,0,0,0,192,0,160,0,209,0,0,0,223,0,0,0,183,0,0,0,106,0,0,0,0,0,163,0,197,0,222,0,221,0,21,0,226,0,0,0,246,0,102,0,0,0,164,0,78,0,130,0,230,0,0,0,126,0,0,0,123,0,0,0,79,0,243,0,144,0,218,0,164,0,189,0,209,0,230,0,194,0,63,0,100,0,135,0,179,0,193,0,97,0,17,0,70,0,54,0,169,0,29,0,0,0,0,0,0,0,146,0,0,0,41,0,28,0,173,0);
signal scenario_full  : scenario_type := (0,0,0,0,70,31,70,30,192,31,192,30,71,31,155,31,38,31,40,31,128,31,91,31,19,31,19,30,146,31,146,30,122,31,139,31,139,30,60,31,154,31,10,31,10,30,73,31,188,31,25,31,99,31,1,31,178,31,119,31,140,31,130,31,5,31,83,31,174,31,64,31,125,31,82,31,203,31,137,31,38,31,111,31,48,31,21,31,111,31,111,30,71,31,71,30,55,31,148,31,240,31,218,31,165,31,156,31,245,31,73,31,147,31,147,30,108,31,215,31,186,31,242,31,198,31,198,30,255,31,156,31,56,31,128,31,70,31,201,31,201,30,229,31,251,31,162,31,162,31,147,31,217,31,217,30,42,31,42,30,42,29,67,31,204,31,204,30,204,29,204,28,163,31,204,31,229,31,229,30,229,29,229,28,165,31,198,31,46,31,254,31,130,31,130,30,229,31,58,31,147,31,190,31,186,31,27,31,182,31,68,31,68,31,186,31,238,31,106,31,164,31,208,31,208,30,70,31,70,30,70,29,39,31,255,31,255,30,104,31,234,31,71,31,231,31,59,31,43,31,39,31,57,31,57,30,167,31,251,31,251,30,145,31,145,30,158,31,39,31,39,30,140,31,233,31,115,31,59,31,206,31,206,30,206,29,18,31,18,30,190,31,190,30,37,31,177,31,169,31,183,31,183,30,99,31,99,30,67,31,201,31,11,31,4,31,9,31,129,31,191,31,138,31,251,31,143,31,116,31,7,31,84,31,139,31,135,31,134,31,65,31,186,31,186,30,41,31,114,31,164,31,194,31,80,31,247,31,255,31,162,31,1,31,189,31,127,31,253,31,139,31,139,30,139,29,139,28,66,31,197,31,168,31,168,30,189,31,52,31,5,31,97,31,70,31,70,30,161,31,236,31,123,31,110,31,110,30,13,31,70,31,150,31,76,31,76,30,76,29,182,31,72,31,144,31,152,31,44,31,198,31,148,31,148,30,68,31,77,31,226,31,15,31,15,30,143,31,143,30,60,31,60,30,203,31,223,31,76,31,197,31,214,31,57,31,57,30,109,31,109,30,109,29,109,28,123,31,123,30,187,31,112,31,112,30,186,31,22,31,109,31,92,31,17,31,138,31,138,30,240,31,17,31,8,31,248,31,248,30,88,31,146,31,234,31,170,31,174,31,198,31,160,31,73,31,216,31,176,31,201,31,215,31,154,31,106,31,162,31,162,30,162,29,12,31,179,31,3,31,12,31,88,31,51,31,110,31,225,31,225,30,243,31,123,31,9,31,177,31,101,31,164,31,75,31,154,31,154,30,184,31,184,30,55,31,75,31,75,30,216,31,146,31,146,30,136,31,235,31,44,31,81,31,207,31,207,30,60,31,60,30,60,29,207,31,207,30,207,29,157,31,116,31,29,31,239,31,202,31,202,30,202,29,153,31,153,30,179,31,130,31,180,31,180,30,125,31,69,31,145,31,93,31,200,31,126,31,126,30,174,31,255,31,255,30,255,29,77,31,82,31,67,31,20,31,144,31,243,31,54,31,90,31,130,31,130,30,84,31,17,31,247,31,247,30,28,31,161,31,61,31,61,30,65,31,65,30,144,31,68,31,13,31,205,31,225,31,194,31,194,30,83,31,248,31,204,31,132,31,113,31,220,31,14,31,14,30,215,31,52,31,52,30,90,31,58,31,161,31,251,31,251,30,108,31,118,31,118,30,104,31,94,31,144,31,223,31,43,31,33,31,211,31,165,31,65,31,65,30,38,31,38,30,235,31,169,31,169,30,169,29,97,31,16,31,16,30,183,31,7,31,241,31,137,31,137,30,186,31,232,31,91,31,27,31,27,30,27,29,142,31,142,30,192,31,160,31,209,31,209,30,223,31,223,30,183,31,183,30,106,31,106,30,106,29,163,31,197,31,222,31,221,31,21,31,226,31,226,30,246,31,102,31,102,30,164,31,78,31,130,31,230,31,230,30,126,31,126,30,123,31,123,30,79,31,243,31,144,31,218,31,164,31,189,31,209,31,230,31,194,31,63,31,100,31,135,31,179,31,193,31,97,31,17,31,70,31,54,31,169,31,29,31,29,30,29,29,29,28,146,31,146,30,41,31,28,31,173,31);

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
